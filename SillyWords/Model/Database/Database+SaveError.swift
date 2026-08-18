//
//  Database+SaveError.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/18/26.
//

import Foundation
import CoreData
import CloudKit

extension Database {
    enum SaveError: Error {
        
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
        
        init(_ error: Error) {
            let nsError = error as NSError

            // 1. Multiple validation errors bundled together
            if let detailedErrors = nsError.userInfo[NSDetailedErrorsKey] as? [NSError] {
                let details = detailedErrors.map { Self.extractValidationDetail(from: $0) }
                for detail in details {
                    print("  • \(detail.description)")
                }
                self = .validationFailed(details: details)
                return
            }

            // 2. Single validation error
            if nsError.domain == NSCocoaErrorDomain,
               (1550...1599).contains(nsError.code) {
                let detail = Self.extractValidationDetail(from: nsError)
                print("  • \(detail.description)")
                self = .validationFailed(details: [detail])
                return
            }

            // 3. CloudKit error hiding underneath
            if let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? NSError,
               underlying.domain == CKErrorDomain {
                let ckError = CKError(_nsError: underlying)
                print("  • CloudKit code \(ckError.code.rawValue): \(ckError.localizedDescription)")
                self = Self.diagnoseCloudKit(ckError)
                return
            }

            // 4. Persistent store save failure (disk, permissions, migration, etc)
            if nsError.domain == NSCocoaErrorDomain, nsError.code == NSPersistentStoreSaveError {
                print("  • Persistent store error: \(nsError.userInfo)")
                self = Self.diagnosePersistentStore(nsError)
                return
            }

            // 5. Merge conflicts
            if nsError.domain == NSCocoaErrorDomain,
               nsError.code == NSManagedObjectMergeError || nsError.code == NSPersistentStoreSaveConflictsError {
                print("  • Merge conflict details: \(nsError.userInfo)")
                self = Self.diagnoseMergeConflict(nsError)
                return
            }

            // 6. Anything else
            print("  • Unrecognized error domain/code: \(nsError.domain) / \(nsError.code)")
            print("  • Full userInfo: \(nsError.userInfo)")
            self = .unknown(underlying: nsError)
            return
        }
        
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
}

extension Database.SaveError {
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
}

extension Database.SaveError {
    private static func diagnosePersistentStore(_ error: NSError) -> Database.SaveError {
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

    private static func diagnoseCloudKit(_ ckError: CKError) -> Database.SaveError {
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

    private static func diagnoseMergeConflict(_ error: NSError) -> Database.SaveError {
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
