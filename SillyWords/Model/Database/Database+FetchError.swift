//
//  Database+FetchError.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/18/26.
//

import Foundation
import CoreData

// MARK: Base
extension Database {
    enum FetchError: Error {
        // MARK: Cases
        case persistentStoreUnreachable(String)
        case migrationRequired(String)
        case validationFailed(String)
        case mergeConflict(String)
        case sqliteError(String)
        case unknown(NSError)
        
        // MARK: Initializers
        init(_ error: Error) {
            let nsError = error as NSError
                
            guard nsError.domain == NSCocoaErrorDomain else {
                self = .unknown(nsError)
                return
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
                self = .persistentStoreUnreachable(nsError.localizedDescription)
                return
                
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
                self = .migrationRequired(nsError.localizedDescription)
                return
                
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
                self = .validationFailed(nsError.localizedDescription)
                return
                
            // Merge conflicts (more common on save, but can surface if fetch triggers a merge)
            case NSManagedObjectMergeError,
                 NSManagedObjectConstraintMergeError,
                 NSPersistentStoreSaveConflictsError,
                 NSManagedObjectReferentialIntegrityError,
                 NSManagedObjectExternalRelationshipError:
                self = .mergeConflict(nsError.localizedDescription)
                return
                
            // Underlying SQLite-level failure
            case NSSQLiteError:
                self = .sqliteError(nsError.localizedDescription)
                return
                
            default:
                self = .unknown(nsError)
                return
            }
        }
    }
}

// MARK: Description
extension Database.FetchError {
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
