//
//  Database+BatchDeleteError.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/18/26.
//

import Foundation
import CoreData

// MARK: Base
extension Database {
    enum BatchDeleteError: Error {
        // MARK: Cases
        case unsupportedStoreType(String)      // store can't handle NSBatchDeleteRequest
        case denyDeleteRuleViolation(String)   // relationship has a "Deny" delete rule
        case persistentStoreFailure(String)    // disk/permissions/coordinator issue
        case sqliteFailure(String)             // underlying SQLite execution error
        case invalidResultType(String)         // requested resultType store can't produce
        case unknown(NSError)
        
        // MARK: Initializers
        init(_ error: Error) {
            let nsError = error as NSError
            
            guard nsError.domain == NSCocoaErrorDomain else {
                self = .unknown(nsError)
                return
            }
            
            switch nsError.code {
            // Store doesn't support this request type at all
            // (e.g. some older in-memory / non-SQLite store configurations)
            case NSPersistentStoreUnsupportedRequestTypeError:
                self = .unsupportedStoreType(nsError.localizedDescription)
                return
                
            // "Deny" delete rule: objects can't be removed because dependents still reference them
            case NSValidationRelationshipDeniedDeleteError:
                self = .denyDeleteRuleViolation(nsError.localizedDescription)
                return
                
            // Coordinator / file-level issues (disk full, permissions, file missing, locked)
            case NSPersistentStoreOpenError,
                 NSPersistentStoreOperationError,
                 NSPersistentStoreTimeoutError,
                 NSPersistentStoreIncompatibleVersionHashError,
                 NSPersistentStoreIncompatibleSchemaError:
                self = .persistentStoreFailure(nsError.localizedDescription)
                return
                
            // Underlying SQLite engine failure
            case NSSQLiteError:
                self = .sqliteFailure(nsError.localizedDescription)
                return
                
            default:
                self = .unknown(nsError)
                return
            }
        }
    }
}

// MARK: Description
extension Database.BatchDeleteError {
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
