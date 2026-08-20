//
//  DatabaseError.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/18/26.
//

import Foundation

enum DatabaseError: Error {
    case missingObject
    case saveFailure(Database.SaveError)
    case fetchFailure(Database.FetchError)
    case batchDeleteFailure(Database.BatchDeleteError)
    
    var description: String {
        return switch self {
        case .missingObject: "The operation could not be completed because the object is missing"
        case .saveFailure(let saveError): "An error occurred while saving - \(saveError.description)"
        case .fetchFailure(let fetchError): "An error occured while fetching - \(fetchError.description)"
        case .batchDeleteFailure(let deleteError): "An error occurred while deleting records - \(deleteError.description)"
        }
    }
}
