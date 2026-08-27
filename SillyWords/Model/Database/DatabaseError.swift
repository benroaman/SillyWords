//
//  DatabaseError.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/25/26.
//

import CoreData
import CloudKit

enum DatabaseError: Error {
    case validation(ErrorInfo, ValidationInfo)
    case permission(ErrorInfo)
    case diskFull(ErrorInfo)
    case badFile(ErrorInfo)
    case miscCoreData(ErrorInfo)
    case missingObject(ErrorIdentity)
    case noPersistentStoreDescription(ErrorIdentity)
    case unknown(ErrorInfo)
    
    init(_ error: Error, operation: Operation, caller: Caller) {
        self = Self.parseError(error as NSError, operation: operation, caller: caller)
    }
    
    static func makeMissingObject(operation: Operation, caller: Caller) -> Self {
        return .missingObject(.init(code: "SWMissingObject", operation: operation, caller: caller))
    }
    
    static func makeNoPersistentStoreDescription(operation: Operation, caller: Caller) -> Self {
        return .noPersistentStoreDescription(.init(code: "SWNoPersistentStoreDescription", operation: operation, caller: caller))
    }
    
    var category: String {
        switch self {
        case .validation: "validation"
        case .permission: "permission"
        case .diskFull: "diskFull"
        case .badFile: "badFile"
        case .miscCoreData: "miscCoreData"
        case .missingObject: "missingObject"
        case .noPersistentStoreDescription: "noPersistentStoreDescription"
        case .unknown: "unknown"
        }
    }
    
    var userMessage: String? {
        switch self.identity.caller {
        case .initializer:
            var result = "Database failed to initialize: "
            switch self {
            case .permission: result += "Permission denied"
            case .diskFull: result += "Disk is full"
            case .badFile: result += "Database is inaccessible"
            case .validation, .miscCoreData, .missingObject, .noPersistentStoreDescription, .unknown: result += identity.code
            }
            return result
        default:
            switch self {
            case .permission: return "Permission denied"
            case .diskFull: return "Disk is full"
            case .badFile: return "Database is inaccessible"
            case .validation, .miscCoreData, .missingObject, .noPersistentStoreDescription, .unknown: return nil
            }
        }
    }
    
    var identity: ErrorIdentity {
        switch self {
        case .validation(let info, _), .permission(let info), .diskFull(let info), .badFile(let info), .miscCoreData(let info), .unknown(let info): info.identity
        case .missingObject(let identity), .noPersistentStoreDescription(let identity): identity
        }
    }
    
    var info: ErrorInfo? {
        switch self {
        case .validation(let info, _), .permission(let info), .diskFull(let info), .badFile(let info), .miscCoreData(let info), .unknown(let info): info
        case .missingObject, .noPersistentStoreDescription: nil
        }
    }
    
    var validation: ValidationInfo? {
        switch self {
        case .validation(_, let validation): validation
        case .permission, .diskFull, .badFile, .miscCoreData, .unknown, .missingObject, .noPersistentStoreDescription: nil
        }
    }
}

private extension DatabaseError {
    static func parseError(_ error: NSError, operation: Operation, caller: Caller) -> DatabaseError {
        let identity = ErrorIdentity(code: errorCodeAsString(error.code),
                                     operation: operation,
                                     caller: caller)
        
        if let underlying = error.userInfo[NSUnderlyingErrorKey] as? NSError,
           underlying.domain == NSSQLiteErrorDomain,
           let code = SQLiteCode(rawValue: underlying.code) {
            switch code {
            case .full: return .diskFull(ErrorInfo(error, identity))
            case .auth, .readOnly: return .permission(ErrorInfo(error, identity))
            case .corrupt, .notADB, .cantOpen: return .badFile(ErrorInfo(error, identity))
            }
        }
        
        switch error.code {
        case NSValidationMultipleErrorsError:
            return .validation(ErrorInfo(error, identity), ValidationInfo(multipleValidationError: error))
        case NSValidationInvalidURIError,
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
        NSValidationStringPatternMatchingError,
        NSManagedObjectConstraintValidationError,
        NSManagedObjectValidationError:
            return .validation(ErrorInfo(error, identity), ValidationInfo(singleValidationError: error))
        case NSCoreDataError,
        NSEntityMigrationPolicyError,
        NSExternalRecordImportError,
        NSInferredMappingModelError,
        NSManagedObjectConstraintMergeError,
        NSManagedObjectContextLockingError,
        NSManagedObjectExternalRelationshipError,
        NSManagedObjectMergeError,
        NSManagedObjectModelReferenceNotFoundError,
        NSManagedObjectReferentialIntegrityError,
        NSMigrationCancelledError,
        NSMigrationConstraintViolationError,
        NSMigrationError,
        NSMigrationManagerDestinationStoreError,
        NSMigrationManagerSourceStoreError,
        NSMigrationMissingMappingModelError,
        NSMigrationMissingSourceModelError,
        NSPersistentHistoryTokenExpiredError,
        NSPersistentStoreCoordinatorLockingError,
        NSPersistentStoreIncompatibleSchemaError,
        NSPersistentStoreIncompatibleVersionHashError,
        NSPersistentStoreIncompleteSaveError,
        NSPersistentStoreInvalidTypeError,
        NSPersistentStoreOpenError,
        NSPersistentStoreOperationError,
        NSPersistentStoreSaveConflictsError,
        NSPersistentStoreSaveError,
        NSPersistentStoreTimeoutError,
        NSPersistentStoreTypeMismatchError,
        NSPersistentStoreUnsupportedRequestTypeError,
        NSSQLiteError,
        NSStagedMigrationBackwardMigrationError,
        NSStagedMigrationFrameworkVersionMismatchError:
            return .miscCoreData(ErrorInfo(error, identity))
        default:
            return .unknown(ErrorInfo(error, identity))
            
        }
    }
}


private extension DatabaseError {
    /// https://developer.apple.com/documentation/coredata/error-codes
    static func errorCodeAsString(_ code: Int) -> String {
        switch code {
        // An error code that indicates a nonspecific Core Data error.
        case NSCoreDataError: "NSCoreDataError"
        // Error code to denote a migration failure during processing of an entity migration policy.
        case NSEntityMigrationPolicyError: "NSEntityMigrationPolicyError"
        // Error code to denote a general error encountered while importing external records.
        case NSExternalRecordImportError: "NSExternalRecordImportError"
        // Error code to denote a problem with the creation of an inferred mapping model.
        case NSInferredMappingModelError: "NSInferredMappingModelError"
        // Error code to denote a problem with the merging of instances of a managed object.
        case NSManagedObjectConstraintMergeError: "NSManagedObjectConstraintMergeError"
        // Error code to denote a problem with the validation of a managed object.
        case NSManagedObjectConstraintValidationError: "NSManagedObjectConstraintValidationError"
        // Error code to denote an inability to acquire a lock in a managed object context.
        case NSManagedObjectContextLockingError: "NSManagedObjectContextLockingError"
        // Error code to denote that an object being saved has a relationship containing an object from another store.
        case NSManagedObjectExternalRelationshipError: "NSManagedObjectExternalRelationshipError"
        // Error code to denote that a merge policy failed—Core Data is unable to complete merging.
        case NSManagedObjectMergeError: "NSManagedObjectMergeError"
        // An error code that indicates Core Data isn't able to find or instantiate the referenced object model.
        case NSManagedObjectModelReferenceNotFoundError: "NSManagedObjectModelReferenceNotFoundError"
        // Error code to denote an attempt to fire a fault pointing to an object that does not exist.
        case NSManagedObjectReferentialIntegrityError: "NSManagedObjectReferentialIntegrityError"
        // Error code to denote a generic validation error.
        case NSManagedObjectValidationError: "NSManagedObjectValidationError"
        // Error code to denote that migration failed due to manual cancellation.
        case NSMigrationCancelledError: "NSMigrationCancelledError"
        // Error code to denote a problem with the validation of a managed object during a migration.
        case NSMigrationConstraintViolationError: "NSMigrationConstraintViolationError"
        // Error code to denote a general migration error.
        case NSMigrationError: "NSMigrationError"
        // Error code to denote that migration failed due to a problem with the destination data store.
        case NSMigrationManagerDestinationStoreError: "NSMigrationManagerDestinationStoreError"
        // Error code to denote that migration failed due to a problem with the source data store.
        case NSMigrationManagerSourceStoreError: "NSMigrationManagerSourceStoreError"
        // Error code to denote that migration failed due to a missing mapping model.
        case NSMigrationMissingMappingModelError: "NSMigrationMissingMappingModelError"
        // Error code to denote that migration failed due to a missing source data model.
        case NSMigrationMissingSourceModelError: "NSMigrationMissingSourceModelError"
        // Error code to denote that the persistent history token has expired.
        case NSPersistentHistoryTokenExpiredError: "NSPersistentHistoryTokenExpiredError"
        // Error code to denote an inability to acquire a lock in a persistent store.
        case NSPersistentStoreCoordinatorLockingError: "NSPersistentStoreCoordinatorLockingError"
        // Error code to denote that a persistent store returned an error for a save operation.
        case NSPersistentStoreIncompatibleSchemaError: "NSPersistentStoreIncompatibleSchemaError"
        // Error code to denote that entity version hashes in the store are incompatible with the current managed object model.
        case NSPersistentStoreIncompatibleVersionHashError: "NSPersistentStoreIncompatibleVersionHashError"
        // Error code to denote that one or more of the stores returned an error during a save operations.
        case NSPersistentStoreIncompleteSaveError: "NSPersistentStoreIncompleteSaveError"
        // Error code to denote an unknown persistent store type/format/version.
        case NSPersistentStoreInvalidTypeError: "NSPersistentStoreInvalidTypeError"
        // Error code to denote an error occurred while attempting to open a persistent store.
        case NSPersistentStoreOpenError: "NSPersistentStoreOpenError"
        // Error code to denote that a persistent store operation failed.
        case NSPersistentStoreOperationError: "NSPersistentStoreOperationError"
        // Error code to denote that an unresolved merge conflict was encountered during a save. .
        case NSPersistentStoreSaveConflictsError: "NSPersistentStoreSaveConflictsError"
        // Error code to denote that a persistent store returned an error for a save operation.
        case NSPersistentStoreSaveError: "NSPersistentStoreSaveError"
        // Error code to denote that Core Data failed to connect to a persistent store within the time specified by NSPersistentStoreTimeoutOption.
        case NSPersistentStoreTimeoutError: "NSPersistentStoreTimeoutError"
        // Error code returned by a persistent store coordinator if a store is accessed that does not match the specified type.
        case NSPersistentStoreTypeMismatchError: "NSPersistentStoreTypeMismatchError"
        // Error code to denote that an NSPersistentStore subclass was passed a request (an instance of NSPersistentStoreRequest) that it did not understand.
        case NSPersistentStoreUnsupportedRequestTypeError: "NSPersistentStoreUnsupportedRequestTypeError"
        // Error code to denote a general SQLite error.
        case NSSQLiteError: "NSSQLiteError"
        // An error code that indicates a failed migration because of an attempt to migrate backward.
        case NSStagedMigrationBackwardMigrationError: "NSStagedMigrationBackwardMigrationError"
        // An error code that indicates a failed migration because the persistent store's metadata doesn't support staged lightweight migrations.
        case NSStagedMigrationFrameworkVersionMismatchError: "NSStagedMigrationFrameworkVersionMismatchError"
        // Error code to denote a problem with the validation of a URI property.
        case NSValidationInvalidURIError: "NSValidationInvalidURIError"
        // Error code to denote an error containing multiple validation errors.
        case NSValidationMultipleErrorsError: "NSValidationMultipleErrorsError"
        // Error code for a non-optional property with a nil value.
        case NSValidationMissingMandatoryPropertyError: "NSValidationMissingMandatoryPropertyError"
        // Error code to denote a to-many relationship with too few destination objects.
        case NSValidationRelationshipLacksMinimumCountError: "NSValidationRelationshipLacksMinimumCountError"
        // Error code to denote a bounded to-many relationship with too many destination objects.
        case NSValidationRelationshipExceedsMaximumCountError: "NSValidationRelationshipExceedsMaximumCountError"
        // Error code to denote some relationship with delete rule NSDeleteRuleDeny is non-empty.
        case NSValidationRelationshipDeniedDeleteError: "NSValidationRelationshipDeniedDeleteError"
        // Error code to denote some numerical value is too large.
        case NSValidationNumberTooLargeError: "NSValidationNumberTooLargeError"
        // Error code to denote some numerical value is too small.
        case NSValidationNumberTooSmallError: "NSValidationNumberTooSmallError"
        // Error code to denote some date value is too late.
        case NSValidationDateTooLateError: "NSValidationDateTooLateError"
        // Error code to denote some date value is too soon.
        case NSValidationDateTooSoonError: "NSValidationDateTooSoonError"
        // Error code to denote some date value fails to match date pattern.
        case NSValidationInvalidDateError: "NSValidationInvalidDateError"
        // Error code to denote some string value is too long.
        case NSValidationStringTooLongError: "NSValidationStringTooLongError"
        // Error code to denote some string value is too short.
        case NSValidationStringTooShortError: "NSValidationStringTooShortError"
        // Error code to denote some string value fails to match some pattern.
        case NSValidationStringPatternMatchingError: "NSValidationStringPatternMatchingError"
        default: "UnknownCoreDataErrorCode-\(code)"
        }
    }
}

// MARK: Support Types
extension DatabaseError {
    enum Operation: String {
        case loadPersistentStores = "NSPersistentCloudKitContainer.loadPersistentStores"
        case setQueryGenerationFrom = "NSManagedObjectContext.setQueryGenerationFrom"
        case save = "NSManagedObjectContext.save"
        case fetch = "NSManagedObjectContext.fetch"
        case execute = "NSManagedObjectContext.execute"
        case persistentStoreDescriptions = "NSPersistentCloudKitContainer.persistentStoreDescriptions.first"
        case object = "NSManagedObjectContext.object"
        case count = "NSManagedObjectContext.count"
        case first = "NSManagedObjectContext.fetch.first"
    }
    
    enum Caller: String {
        case initializer
        case createWord
        case removeFavoriteByObject
        case removeFavoriteByText
        case removeAllFavorites
        case getWord
        case allFavoriteWordStrings
        case rateWord
        case seedPreviewDatabase
        case deleteWordHistory
        case deleteWordByObject
        case deleteWordByText
        case addFavoriteByObject
        case addFavoriteByText
        case portFavoritesToWords
        case hasFavorites
        case doesWordExist
        case toggleFavoriteByText
        case toggleFavoriteByObject
        case isFavorite
    }
    
    enum SQLiteCode: Int {
        case readOnly = 8
        case corrupt = 11
        case full = 13
        case cantOpen = 14
        case auth = 23
        case notADB = 26
    }
}

extension DatabaseError {
    struct ErrorIdentity {
        let code: String
        let operation: DatabaseError.Operation
        let caller: DatabaseError.Caller
    }
    
    struct ErrorInfo {
        let identity: ErrorIdentity
        let description: String?
        let reason: String?
        let suggestion: String?
        let underlyingCode: String?
        let underlyingReason: String?
        let underlyingSuggestion: String?
        let underlyingDescription: String?
        
        init(_ error: NSError, _ identity: ErrorIdentity) {
            self.identity = identity
            self.description = error.localizedDescription
            self.reason = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String
            self.suggestion = error.userInfo[NSLocalizedRecoverySuggestionErrorKey] as? String
            if let underlying = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                if underlying.domain == NSSQLiteErrorDomain {
                    self.underlyingCode = String(underlying.code)
                } else {
                    self.underlyingCode = DatabaseError.errorCodeAsString(underlying.code)
                }
                
                self.underlyingReason = underlying.userInfo[NSLocalizedFailureReasonErrorKey] as? String
                self.underlyingSuggestion = underlying.userInfo[NSLocalizedRecoverySuggestionErrorKey] as? String
                self.underlyingDescription = underlying.localizedDescription
            } else {
                self.underlyingCode = nil
                self.underlyingReason = nil
                self.underlyingSuggestion = nil
                self.underlyingDescription = nil
            }
        }
    }
    
    struct ValidationInfo {
        let validationKey: String?
        let validationValue: Any?
        let validationPredicate: String?
        
        init(singleValidationError error: NSError) {
            self.validationKey = error.userInfo[NSValidationKeyErrorKey] as? String
            if let value = error.userInfo[NSValidationValueErrorKey] {
                self.validationValue = "\(value)"
            } else {
                self.validationValue = nil
            }
            if let predicate = error.userInfo[NSValidationPredicateErrorKey] as? NSPredicate {
                self.validationPredicate = predicate.predicateFormat
            } else {
                self.validationPredicate = nil
            }
        }
        
        init(multipleValidationError error: NSError) {
            if let errors = error.userInfo[NSDetailedErrorsKey] as? [NSError] {
                var keyInfo: String = "::"
                var valueInfo: String = "::"
                var predicateInfo: String = "::"
                for (i, e) in errors.enumerated() {
                    keyInfo += " \(i) " + (e.userInfo[NSValidationKeyErrorKey] as? String ?? "nil") + " ::"
                    if let value = e.userInfo[NSValidationValueErrorKey] {
                        valueInfo += " \(i) " + "\(value)" + " ::"
                    } else {
                        valueInfo += " \(i) nil ::"
                    }
                    if let predicate = e.userInfo[NSValidationPredicateErrorKey] as? NSPredicate {
                        predicateInfo += " \(i) " + predicate.predicateFormat + " ::"
                    }
                }
                self.validationKey = keyInfo
                self.validationValue = valueInfo
                self.validationPredicate = predicateInfo
            } else {
                self.validationKey = nil
                self.validationValue = nil
                self.validationPredicate = nil
            }
        }
    }
}
