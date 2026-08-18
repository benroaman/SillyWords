//
//  Database.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/10/26.
//

//
//  PersistenceController.swift
//  Standard CloudKit + Core Data implementation
//
//  Requirements before this works:
//  1. Add the "iCloud" capability in Signing & Capabilities, enable CloudKit,
//     and select/create a container (e.g. iCloud.com.yourcompany.yourapp).
//  2. Add the "Background Modes" capability -> check "Remote notifications".
//  3. In your .xcdatamodeld, every entity needs:
//       - a unique constraint (or at least all attributes optional/defaulted)
//       - all relationships must be optional
//       - no attribute called "id" of type undefined — CloudKit adds its own
//         metadata columns automatically, don't create your own.
//

import CoreData
import CloudKit
import BRWordGeneration

struct Database {
    let container: NSPersistentCloudKitContainer
    let viewContext: NSManagedObjectContext
    private let writeContext: NSManagedObjectContext
    
    static var preview: Database = {
        let controller = Database(inMemory: true)
        let context = controller.container.viewContext

        // Create sample objects
        let mock1 = Flavorite(context: context)
        mock1.word = "glunde"
        mock1.dateAdded = Date()
        mock1.actualSyllables = 2
        let mock2 = Flavorite(context: context)
        mock1.word = "bismustrex"
        mock1.dateAdded = Date()
        mock1.actualSyllables = 3
        let mock3 = Flavorite(context: context)
        mock1.word = "aja"
        mock1.dateAdded = Date()
        mock1.actualSyllables = 2

        do {
            try Database.save(context)
        } catch let error as DatabaseError {
            fatalError("Failed to save preview data: \(error.description)")
        } catch {
            fatalError("Failed to save preview data: \(error.localizedDescription)")
        }

        return controller
    }()

    init(inMemory: Bool = false) {
        // Name must match your .xcdatamodeld filename
        container = NSPersistentCloudKitContainer(name: "SillyWords")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No persistent store description found")
        }

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.sillywords-user-data"
        )

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // In production, handle this gracefully (e.g. corrupt store,
                // disk full, no iCloud account). Don't fatalError in shipped code.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Automatically merge changes coming in from CloudKit
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        // Pin the view context to the current query generation so it doesn't
        // see partial updates mid-sync
        try? container.viewContext.setQueryGenerationFrom(.current)

        #if DEBUG
        // Uncomment once, run on a real device signed into iCloud, to create
        // the CloudKit schema from your Core Data model automatically.
        // do {
        //     try container.initializeCloudKitSchema(options: [])
        // } catch {
        //     print("Schema init failed: \(error)")
        // }
        #endif

        // Listen for remote (CloudKit-driven) changes if you want to react to them
//        NotificationCenter.default.addObserver(
//            forName: .NSPersistentStoreRemoteChange,
//            object: container.persistentStoreCoordinator,
//            queue: .main
//        ) { _ in
//            print("Remote change detected from CloudKit")
//        }
        self.viewContext = container.viewContext
        self.writeContext = container.newBackgroundContext()
    }

    // Convenience save with error handling
    private static func save(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }

        do {
            try context.saveWithDiagnostics()
        } catch let error as DatabaseSaveError {
            print(error.localizedDescription)
            throw DatabaseError.parsableSaveFailure(error)
        } catch {
            // Non-SaveContextError, shouldn't normally happen
            print("Unparsable save error: \(error.localizedDescription)")
            throw DatabaseError.unparsableSaveFailure(error)
        }
    }
    
    func createFavorite(content: GeneratedWord) async throws {
        try await writeContext.perform {
            let new = Flavorite(context: writeContext)
            new.word = content.word
            new.actualSyllables = Int64(content.syllables)
            new.dateAdded = Date()
            
            new.minSyllables = Int64(content.settings.minSyllables)
            new.maxSyllables = Int64(content.settings.maxSyllables)
            new.allowVowelCombos = content.settings.allowVowelCombos
            new.allowsYAsVowel = content.settings.allowsYAsVowel
            new.filterSortOfBadWords = content.settings.filterSortOfBadWords
            new.soloQs = content.settings.soloQs
            new.initialDigraphs = content.settings.initialDigraphs
            new.initialDigraphBlends = content.settings.initialDigraphBlends
            new.initial2LetterBlends = content.settings.initial2LetterBlends
            new.initial3LetterBlends = content.settings.initial3LetterBlends
            new.middleDigraphs = content.settings.middleDigraphs
            new.middleDigraphBlends = content.settings.middleDigraphBlends
            new.middle2LetterBlends = content.settings.middle2LetterBlends
            new.middle3LetterBlends = content.settings.middle3LetterBlends
            new.finalDigraphs = content.settings.finalDigraphs
            new.finalDigraphBlends = content.settings.finalDigraphBlends
            new.final2LetterBlends = content.settings.final2LetterBlends
            new.final3LetterBlends = content.settings.final3LetterBlends
            
            try Self.save(writeContext)
        }
    }
    
    func deleteFavorite(_ favorite: Flavorite) async throws {
        let objectID = favorite.objectID
        let writeContext = self.writeContext
        try await writeContext.perform {
            let object = writeContext.object(with: objectID)
            writeContext.delete(object)
            try Self.save(writeContext)
        }
    }
    
    func deleteFavorite(_ word: String) async throws {
        let writeContext = self.writeContext
        try await writeContext.perform {
            let request = Flavorite.fetchRequest()
            request.predicate = NSPredicate(format: "word ==[c] %@", word)
            
            do {
                for object in try writeContext.fetch(request) {
                    writeContext.delete(object)
                }
            } catch {
                throw DatabaseError.fetchFailure(Database.parseFetchError(error))
            }
            try Self.save(writeContext)
        }
    }
    
    func clearAllFavorites() async throws {
        let context = writeContext
        let readContext = viewContext
        
        try await context.perform {
            let fetchRequest = Flavorite.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                let deletedObjectIDs = result?.result as? [NSManagedObjectID] ?? []
                
                let changes = [NSDeletedObjectsKey: deletedObjectIDs]
                
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [readContext] // add other live contexts here
                )
            } catch {
                throw DatabaseError.batchDeleteFailure(Database.parseBatchDeleteError(error))
            }
        }
    }
    
    func rateFavorite(_ favorite: Flavorite, rating: Int) async throws {
        let objectID = favorite.objectID
        let writeContext = self.writeContext
        try await writeContext.perform {
            guard let object = writeContext.object(with: objectID) as? Flavorite else {
                throw DatabaseError.missingObject
            }
            object.rating = Int64(rating)
            try Self.save(writeContext)
        }
    }
    
    func getWord(from favorite: Flavorite) async -> String? {
        let objectID = favorite.objectID
        let readContext = viewContext
        return await readContext.perform {
            (readContext.object(with: objectID) as? Flavorite)?.word
        }
    }
    
    func allFavoriteWordStrings() -> Set<String> {
        let readContext = viewContext
        
        do {
            return try readContext.performAndWait {
                let words = try readContext .fetch(Flavorite.fetchRequest()).compactMap(\.word)
                return Set(words)
            }
        } catch {
            print("Failed to intialize favorites reference list: \(Database.parseFetchError(error).description)")
            return []
        }
    }
    
    private static func parseFetchError(_ error: Error) -> CoreDataFetchError {
        let nsError = error as NSError
            
        guard nsError.domain == NSCocoaErrorDomain else {
            return .unknown(nsError)
        }
        
        switch nsError.code {
        // Persistent store connectivity / file access
        case NSPersistentStoreIncompatibleVersionHashError,
             NSPersistentStoreOperationError,
             NSPersistentStoreOpenError,
             NSPersistentStoreTimeoutError,
             NSPersistentStoreUnsupportedRequestTypeError,
             NSPersistentStoreIncompatibleSchemaError,
             NSPersistentStoreTypeMismatchError,
             NSPersistentStoreInvalidTypeError:
            return .persistentStoreUnreachable(nsError.localizedDescription)
            
        // Migration-related
        case NSMigrationError,
             NSMigrationConstraintViolationError,
             NSMigrationCancelledError,
             NSMigrationMissingSourceModelError,
             NSMigrationMissingMappingModelError,
             NSMigrationManagerSourceStoreError,
             NSMigrationManagerDestinationStoreError,
             NSEntityMigrationPolicyError,
             NSInferredMappingModelError:
            return .migrationRequired(nsError.localizedDescription)
            
        // Validation errors
        case NSManagedObjectValidationError,
             NSManagedObjectConstraintValidationError,
             NSValidationMultipleErrorsError,
             NSValidationMissingMandatoryPropertyError,
             NSValidationRelationshipLacksMinimumCountError,
             NSValidationRelationshipExceedsMaximumCountError,
             NSValidationRelationshipDeniedDeleteError,
             NSValidationNumberTooLargeError,
             NSValidationNumberTooSmallError,
             NSValidationDateTooLateError,
             NSValidationDateTooSoonError,
             NSValidationInvalidDateError,
             NSValidationStringTooLongError,
             NSValidationStringTooShortError,
             NSValidationStringPatternMatchingError:
            return .validationFailed(nsError.localizedDescription)
            
        // Merge conflicts (more common on save, but can surface if fetch triggers a merge)
        case NSManagedObjectMergeError,
             NSManagedObjectConstraintMergeError,
             NSPersistentStoreSaveConflictsError,
             NSManagedObjectReferentialIntegrityError,
             NSManagedObjectExternalRelationshipError:
            return .mergeConflict(nsError.localizedDescription)
            
        // Underlying SQLite-level failure
        case NSSQLiteError:
            return .sqliteError(nsError.localizedDescription)
            
        default:
            return .unknown(nsError)
        }
    }
    
    private static func parseBatchDeleteError(_ error: Error) -> BatchDeleteError {
        let nsError = error as NSError
        
        guard nsError.domain == NSCocoaErrorDomain else {
            return .unknown(nsError)
        }
        
        switch nsError.code {
        // Store doesn't support this request type at all
        // (e.g. some older in-memory / non-SQLite store configurations)
        case NSPersistentStoreUnsupportedRequestTypeError:
            return .unsupportedStoreType(nsError.localizedDescription)
            
        // "Deny" delete rule: objects can't be removed because dependents still reference them
        case NSValidationRelationshipDeniedDeleteError:
            return .denyDeleteRuleViolation(nsError.localizedDescription)
            
        // Coordinator / file-level issues (disk full, permissions, file missing, locked)
        case NSPersistentStoreOpenError,
             NSPersistentStoreOperationError,
             NSPersistentStoreTimeoutError,
             NSPersistentStoreIncompatibleVersionHashError,
             NSPersistentStoreIncompatibleSchemaError:
            return .persistentStoreFailure(nsError.localizedDescription)
            
        // Underlying SQLite engine failure
        case NSSQLiteError:
            return .sqliteFailure(nsError.localizedDescription)
            
        default:
            return .unknown(nsError)
        }
    }
}

enum DatabaseError: Error {
    case missingObject
    case parsableSaveFailure(DatabaseSaveError)
    case unparsableSaveFailure(Error)
    case fetchFailure(CoreDataFetchError)
    case batchDeleteFailure(BatchDeleteError)
    
    var description: String {
        return switch self {
        case .missingObject: "The operation could not be completed because the object is missing"
        case .parsableSaveFailure(let saveError): "An error occurred while saving - \(saveError.description)"
        case .unparsableSaveFailure(let saveError): "An error occurred while saving - \(saveError.localizedDescription)"
        case .fetchFailure(let fetchError): "An error occured while fetching - \(fetchError.description)"
        case .batchDeleteFailure(let deleteError): "An error occurred while deleting records - \(deleteError.description)"
        }
    }
}

//
//  DatabaseSaveError.swift
//  Wraps NSManagedObjectContext.save() with detailed diagnostics
//  and a typed error you can switch over at the call site.
//

import CoreData
import CloudKit

// MARK: - Custom Error Type

enum DatabaseSaveError: Error {

    /// One or more attributes/relationships failed model validation
    /// (e.g. missing required value, relationship count out of range).
    case validationFailed(details: [ValidationFailureDetail])

    // MARK: Persistent store save failure — broken out by underlying cause

    /// The disk ran out of space while writing the store file.
    case diskFull(underlying: NSError)

    /// The store file (or its journal/WAL) couldn't be written due to
    /// file permissions or another process holding a lock on it.
    case fileAccessDenied(underlying: NSError)

    /// The store's on-disk schema doesn't match the current managed object
    /// model, and a migration is required before saving can succeed.
    case migrationRequired(underlying: NSError)

    /// SQLite itself reported a failure (corruption, malformed database,
    /// busy/locked database file, etc). `sqliteErrorCode` is SQLite's own
    /// numeric code when available, e.g. 11 = corrupt, 5 = busy.
    case sqliteFailure(sqliteErrorCode: Int?, underlying: NSError)

    /// The save operation exceeded the store's internal timeout, typically
    /// under heavy contention or a very large batch of changes.
    case storeTimeout(underlying: NSError)

    /// The store save failed for a reason that doesn't match a more
    /// specific case above (still a persistent-store-level failure).
    case persistentStoreSaveFailedOther(underlying: NSError)

    // MARK: CloudKit save failure — broken out by CKError.Code

    /// The user's iCloud storage quota is full.
    case cloudKitQuotaExceeded(ckError: CKError)

    /// No network connection, or the network dropped mid-request.
    case cloudKitNetworkUnavailable(ckError: CKError)

    /// The user isn't signed into iCloud, or iCloud access was revoked
    /// for the app (Settings > [User] > iCloud).
    case cloudKitNotAuthenticated(ckError: CKError)

    /// Another device/context modified the same CloudKit record first;
    /// this is CloudKit's own optimistic-locking conflict.
    case cloudKitRecordConflict(ckError: CKError, serverRecord: CKRecord?)

    /// The CloudKit zone is temporarily too busy to accept the request;
    /// safe to retry after the error's suggested delay.
    case cloudKitZoneBusy(ckError: CKError, retryAfter: TimeInterval?)

    /// A CloudKit request-rate or record-size limit was exceeded.
    case cloudKitLimitExceeded(ckError: CKError)

    /// The app's iCloud account doesn't have permission to write
    /// (e.g. restricted by parental controls or MDM).
    case cloudKitPermissionFailure(ckError: CKError)

    /// CloudKit is temporarily unavailable independent of the network
    /// (server-side outage, maintenance, account temporarily unavailable).
    case cloudKitServiceUnavailable(ckError: CKError)

    /// Any other CKError code not covered by a more specific case above.
    case cloudKitOther(ckError: CKError)

    // MARK: Merge conflict — broken out by cause

    /// Optimistic locking failure: this context's in-memory version of an
    /// object is stale because another context (or CloudKit) saved a newer
    /// version of the same object first.
    case staleObjectConflict(entityName: String?, objectID: NSManagedObjectID?, underlying: NSError)

    /// A unique constraint (declared in the model) was violated — two
    /// objects ended up with the same value for a constrained attribute.
    case uniqueConstraintViolation(entityName: String?, constraintKeys: [String]?, underlying: NSError)

    /// The object being saved was deleted (locally or remotely) before
    /// this save completed, so its changes have nowhere to go.
    case editedObjectDeleted(entityName: String?, objectID: NSManagedObjectID?, underlying: NSError)

    /// A merge conflict occurred but didn't match a more specific case above.
    case mergeConflictOther(underlying: NSError)

    /// Catch-all for anything that didn't match a known Core Data error code.
    case unknown(underlying: NSError)

    var description: String {
        switch self {
        case .validationFailed(let details):
            let summary = details.map { $0.description }.joined(separator: "; ")
            return "Validation failed: \(summary)"

        case .diskFull:
            return "Save failed: the disk is full."
        case .fileAccessDenied:
            return "Save failed: the store file couldn't be accessed (permissions or file lock)."
        case .migrationRequired:
            return "Save failed: the store needs a model migration before it can be saved."
        case .sqliteFailure(let code, let underlying):
            let codeText = code.map { "SQLite code \($0)" } ?? "unknown SQLite code"
            return "Save failed: SQLite error (\(codeText)) — \(underlying.localizedDescription)"
        case .storeTimeout:
            return "Save failed: the store operation timed out."
        case .persistentStoreSaveFailedOther(let underlying):
            return "Persistent store save failed: \(underlying.localizedDescription)"

        case .cloudKitQuotaExceeded:
            return "CloudKit save failed: iCloud storage quota exceeded."
        case .cloudKitNetworkUnavailable:
            return "CloudKit save failed: no network connection."
        case .cloudKitNotAuthenticated:
            return "CloudKit save failed: user isn't signed into iCloud."
        case .cloudKitRecordConflict:
            return "CloudKit save failed: a newer version of this record already exists on the server."
        case .cloudKitZoneBusy(_, let retryAfter):
            let retryText = retryAfter.map { " (retry after \($0)s)" } ?? ""
            return "CloudKit save failed: zone is busy\(retryText)."
        case .cloudKitLimitExceeded:
            return "CloudKit save failed: a request or record-size limit was exceeded."
        case .cloudKitPermissionFailure:
            return "CloudKit save failed: insufficient permissions on this iCloud account."
        case .cloudKitServiceUnavailable:
            return "CloudKit save failed: service temporarily unavailable."
        case .cloudKitOther(let ckError):
            return "CloudKit save failed (\(ckError.code.rawValue)): \(ckError.localizedDescription)"

        case .staleObjectConflict(let entityName, _, _):
            return "Merge conflict: \(entityName ?? "an object") was changed elsewhere before this save completed."
        case .uniqueConstraintViolation(let entityName, let keys, _):
            let keyText = keys?.joined(separator: ", ") ?? "a unique attribute"
            return "Merge conflict: duplicate value for \(keyText) on \(entityName ?? "an object")."
        case .editedObjectDeleted(let entityName, _, _):
            return "Merge conflict: \(entityName ?? "an object") was deleted before this save completed."
        case .mergeConflictOther(let underlying):
            return "Merge conflict: \(underlying.localizedDescription)"

        case .unknown(let underlying):
            return "Unknown save error: \(underlying.localizedDescription)"
        }
    }
}

/// Describes a single validation failure extracted from NSError.userInfo.
struct ValidationFailureDetail {
    let objectDescription: String
    let key: String?
    let value: Any?

    var description: String {
        var parts = [objectDescription]
        if let key { parts.append("key: \(key)") }
        if let value { parts.append("value: \(value)") }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Save Wrapper

extension NSManagedObjectContext {

    /// Saves the context if there are changes, printing a detailed diagnostic
    /// for any failure and throwing a typed `SaveContextError`.
    func saveWithDiagnostics() throws {
        guard hasChanges else { return }

        do {
            try save()
        } catch let error as NSError {
            let mappedError = Self.diagnose(error)
            print("❌ Core Data save failed: \(mappedError.localizedDescription)")
            throw mappedError
        }
    }

    /// Inspects an NSError from a failed save and maps it to a SaveContextError,
    /// printing detailed diagnostics along the way.
    private static func diagnose(_ error: NSError) -> DatabaseSaveError {

        // 1. Multiple validation errors bundled together
        if let detailedErrors = error.userInfo[NSDetailedErrorsKey] as? [NSError] {
            let details = detailedErrors.map { extractValidationDetail(from: $0) }
            for detail in details {
                print("  • \(detail.description)")
            }
            return .validationFailed(details: details)
        }

        // 2. Single validation error
        if error.domain == NSCocoaErrorDomain,
           (1550...1599).contains(error.code) {
            let detail = extractValidationDetail(from: error)
            print("  • \(detail.description)")
            return .validationFailed(details: [detail])
        }

        // 3. CloudKit error hiding underneath
        if let underlying = error.userInfo[NSUnderlyingErrorKey] as? NSError,
           underlying.domain == CKErrorDomain {
            let ckError = CKError(_nsError: underlying)
            print("  • CloudKit code \(ckError.code.rawValue): \(ckError.localizedDescription)")
            return diagnoseCloudKit(ckError)
        }

        // 4. Persistent store save failure (disk, permissions, migration, etc)
        if error.domain == NSCocoaErrorDomain, error.code == NSPersistentStoreSaveError {
            print("  • Persistent store error: \(error.userInfo)")
            return diagnosePersistentStore(error)
        }

        // 5. Merge conflicts
        if error.domain == NSCocoaErrorDomain,
           error.code == NSManagedObjectMergeError || error.code == NSPersistentStoreSaveConflictsError {
            print("  • Merge conflict details: \(error.userInfo)")
            return diagnoseMergeConflict(error)
        }

        // 6. Anything else
        print("  • Unrecognized error domain/code: \(error.domain) / \(error.code)")
        print("  • Full userInfo: \(error.userInfo)")
        return .unknown(underlying: error)
    }

    // MARK: - Persistent store sub-diagnosis

    private static func diagnosePersistentStore(_ error: NSError) -> DatabaseSaveError {
        // The real cause is often nested one or two levels down in
        // NSUnderlyingErrorKey, frequently as an NSSQLiteErrorDomain error.
        let underlying = (error.userInfo[NSUnderlyingErrorKey] as? NSError) ?? error

        // SQLite-level errors carry their own numeric result code, which is
        // far more specific than the wrapping Cocoa error code.
        if underlying.domain == "NSSQLiteErrorDomain" {
            let sqliteCode = underlying.code
            print("  • SQLite result code: \(sqliteCode)")

            switch sqliteCode {
            case 13: // SQLITE_FULL
                return .diskFull(underlying: underlying)
            case 8, 23: // SQLITE_READONLY, SQLITE_AUTH — permission issues
                return .fileAccessDenied(underlying: underlying)
            case 5, 6: // SQLITE_BUSY, SQLITE_LOCKED
                return .storeTimeout(underlying: underlying)
            default:
                return .sqliteFailure(sqliteErrorCode: sqliteCode, underlying: underlying)
            }
        }

        // POSIX errors surface disk-full / permission problems before
        // SQLite even gets involved (e.g. failure creating the WAL file).
        if underlying.domain == NSPOSIXErrorDomain {
            switch underlying.code {
            case Int(ENOSPC): // No space left on device
                return .diskFull(underlying: underlying)
            case Int(EACCES), Int(EPERM):
                return .fileAccessDenied(underlying: underlying)
            default:
                break
            }
        }

        // Migration-related Cocoa error codes.
        let migrationCodes: Set<Int> = [
            NSMigrationError,
            NSMigrationCancelledError,
            NSMigrationMissingSourceModelError,
            NSMigrationMissingMappingModelError,
            NSPersistentStoreIncompatibleVersionHashError
        ]
        if migrationCodes.contains(error.code) || migrationCodes.contains(underlying.code) {
            return .migrationRequired(underlying: error)
        }

        if error.code == NSPersistentStoreTimeoutError {
            return .storeTimeout(underlying: error)
        }

        return .persistentStoreSaveFailedOther(underlying: error)
    }

    // MARK: - CloudKit sub-diagnosis

    private static func diagnoseCloudKit(_ ckError: CKError) -> DatabaseSaveError {
        switch ckError.code {
        case .quotaExceeded:
            return .cloudKitQuotaExceeded(ckError: ckError)

        case .networkUnavailable, .networkFailure:
            return .cloudKitNetworkUnavailable(ckError: ckError)

        case .notAuthenticated:
            return .cloudKitNotAuthenticated(ckError: ckError)

        case .serverRecordChanged:
            let serverRecord = ckError.userInfo[CKRecordChangedErrorServerRecordKey] as? CKRecord
            return .cloudKitRecordConflict(ckError: ckError, serverRecord: serverRecord)

        case .zoneBusy:
            let retryAfter = ckError.userInfo[CKErrorRetryAfterKey] as? TimeInterval
            return .cloudKitZoneBusy(ckError: ckError, retryAfter: retryAfter)

        case .limitExceeded, .requestRateLimited:
            return .cloudKitLimitExceeded(ckError: ckError)

        case .permissionFailure, .managedAccountRestricted:
            return .cloudKitPermissionFailure(ckError: ckError)

        case .serviceUnavailable, .accountTemporarilyUnavailable:
            return .cloudKitServiceUnavailable(ckError: ckError)

        default:
            return .cloudKitOther(ckError: ckError)
        }
    }

    // MARK: - Merge conflict sub-diagnosis

    private static func diagnoseMergeConflict(_ error: NSError) -> DatabaseSaveError {
        // Unique-constraint violations surface as NSConstraintConflict
        // objects under this key rather than the generic merge-conflict key.
        if let constraintConflicts = error.userInfo["NSConstraintConflicts"] as? [NSMergeConflict] {
            // Fallback path if Core Data hands back NSMergeConflict-typed
            // constraint info (varies by OS version); still report as
            // a constraint violation with what we can extract.
            let entityName = constraintConflicts.first?.sourceObject.entity.name
            print("  • Constraint conflict on entity: \(entityName ?? "unknown")")
            return .uniqueConstraintViolation(entityName: entityName, constraintKeys: nil, underlying: error)
        }

        if error.code == NSManagedObjectConstraintMergeError {
            let entityName = (error.userInfo[NSValidationObjectErrorKey] as? NSManagedObject)?.entity.name
            return .uniqueConstraintViolation(entityName: entityName, constraintKeys: nil, underlying: error)
        }

        // Standard optimistic-locking conflict: object was changed elsewhere
        // between being faulted in and this save.
        if let conflictList = error.userInfo["conflictList"] as? [NSMergeConflict],
           let firstConflict = conflictList.first {
            let object = firstConflict.sourceObject
            print("  • Stale object: \(object.entity.name ?? "?") \(object.objectID)")
            return .staleObjectConflict(
                entityName: object.entity.name,
                objectID: object.objectID,
                underlying: error
            )
        }

        // Deleted-object conflict: referenced object no longer exists.
        if error.code == NSManagedObjectReferentialIntegrityError {
            let object = error.userInfo[NSValidationObjectErrorKey] as? NSManagedObject
            return .editedObjectDeleted(
                entityName: object?.entity.name,
                objectID: object?.objectID,
                underlying: error
            )
        }

        return .mergeConflictOther(underlying: error)
    }

    private static func extractValidationDetail(from error: NSError) -> ValidationFailureDetail {
        let object = error.userInfo[NSValidationObjectErrorKey] as? NSManagedObject
        let key = error.userInfo[NSValidationKeyErrorKey] as? String
        let value = error.userInfo[NSValidationValueErrorKey]

        let objectDescription: String
        if let object {
            let entityName = object.entity.name ?? "UnknownEntity"
            objectDescription = "\(entityName) (\(object.objectID))"
        } else {
            objectDescription = "Unknown object"
        }

        return ValidationFailureDetail(objectDescription: objectDescription, key: key, value: value)
    }
}

// MARK: - Example usage

/*
 do {
     try context.saveWithDiagnostics()
 } catch let error as DatabaseSaveError {
     switch error {
     case .validationFailed(let details):
         // Show a targeted alert, e.g. "Title is required" if details[0].key == "title"
         break

     case .diskFull:
         // Prompt the user to free up device storage
         break
     case .fileAccessDenied, .migrationRequired, .sqliteFailure, .storeTimeout, .persistentStoreSaveFailedOther:
         // Generic "something went wrong locally, try again" alert
         break

     case .cloudKitQuotaExceeded:
         // Prompt user about iCloud storage
         break
     case .cloudKitNetworkUnavailable:
         // Silently retry later, or show an offline indicator
         break
     case .cloudKitNotAuthenticated:
         // Prompt user to sign into iCloud in Settings
         break
     case .cloudKitRecordConflict(_, let serverRecord):
         // Resolve conflict — e.g. re-fetch and merge, or let NSPersistentCloudKitContainer's
         // built-in merge policy handle it (it usually already has by this point)
         break
     case .cloudKitZoneBusy, .cloudKitLimitExceeded, .cloudKitServiceUnavailable:
         // Transient — retry with backoff
         break
     case .cloudKitPermissionFailure, .cloudKitOther:
         // Generic CloudKit failure alert
         break

     case .staleObjectConflict:
         // Refresh the object from the context and let the user retry their edit
         break
     case .uniqueConstraintViolation(let entityName, _, _):
         // e.g. "An item with this name already exists"
         break
     case .editedObjectDeleted:
         // Inform the user their edited item was removed elsewhere
         break
     case .mergeConflictOther, .unknown:
         // Generic failure alert
         break
     }
     throw error
 } catch {
     // Non-SaveContextError, shouldn't normally happen
     print("Unparsable save error: \(error.localizedDescription)")
     throw error
 }
*/

enum CoreDataFetchError: Error {
    case persistentStoreUnreachable(String)
    case migrationRequired(String)
    case validationFailed(String)
    case mergeConflict(String)
    case sqliteError(String)
    case unknown(NSError)
    
    var description: String {
        switch self {
        case .persistentStoreUnreachable(let msg): return "Persistent store unreachable: \(msg)"
        case .migrationRequired(let msg): return "Migration required: \(msg)"
        case .validationFailed(let msg): return "Validation failed: \(msg)"
        case .mergeConflict(let msg): return "Merge conflict: \(msg)"
        case .sqliteError(let msg): return "SQLite error: \(msg)"
        case .unknown(let error): return "Unknown Core Data error: \(error.localizedDescription)"
        }
    }
}

enum BatchDeleteError: Error {
    case unsupportedStoreType(String)      // store can't handle NSBatchDeleteRequest
    case denyDeleteRuleViolation(String)   // relationship has a "Deny" delete rule
    case persistentStoreFailure(String)    // disk/permissions/coordinator issue
    case sqliteFailure(String)             // underlying SQLite execution error
    case invalidResultType(String)         // requested resultType store can't produce
    case unknown(NSError)
    
    var description: String {
        switch self {
        case .unsupportedStoreType(let msg): return "Store type doesn't support batch delete: \(msg)"
        case .denyDeleteRuleViolation(let msg): return "Delete denied by relationship rule: \(msg)"
        case .persistentStoreFailure(let msg): return "Persistent store failure: \(msg)"
        case .sqliteFailure(let msg): return "SQLite execution failure: \(msg)"
        case .invalidResultType(let msg): return "Unsupported result type for this store: \(msg)"
        case .unknown(let error): return "Unhandled error [\(error.domain):\(error.code)]: \(error.localizedDescription)"
        }
    }
}
