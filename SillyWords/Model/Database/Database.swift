//
//  Database.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/10/26.
//

import CoreData
import CloudKit
import BRWordGeneration


struct Database {
    // MARK: Instance Constants
    private let container: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    private let writeContext: NSManagedObjectContext
    private(set) var initializeFailureError: String?
    
    // MARK: Initializers
    init(inMemory: Bool = false) {
        
        let failInitialization: (DatabaseError) -> Void = {
            #if DEBUG
            fatalError($0.category)
            #else
            initializeFailureError = $0
            return
            #endif
        }
        
        // Name must match your .xcdatamodeld filename
        container = NSPersistentCloudKitContainer(name: "SillyWords")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions.first?.cloudKitContainerOptions = nil
        } else if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: "iCloud.sillywords-user-data"
            )
            // Pin the view context to the current query generation so it doesn't
            // see partial updates mid-sync
            
            do {
                try container.viewContext.setQueryGenerationFrom(.current)
            } catch {
                failInitialization(DatabaseError(error, operation: .setQueryGenerationFrom, caller: .initializer))
            }
            
        } else {
            failInitialization(.makeNoPersistentStoreDescription(operation: .persistentStoreDescriptions, caller: .initializer))
        }
        
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                // In production, handle this gracefully (e.g. corrupt store,
                // disk full, no iCloud account). Don't fatalError in shipped code.
                failInitialization(DatabaseError(error, operation: .loadPersistentStores, caller: .initializer))
            }
        }
        
        // Automatically merge changes coming in from CloudKit
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        
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
        self.writeContext.automaticallyMergesChangesFromParent = true
        self.writeContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

// MARK: Private API - Save Wrapper
extension Database {
    private static func save(_ context: NSManagedObjectContext, caller: DatabaseError.Caller) throws {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            try throwError(DatabaseError(error, operation: .save, caller: caller))
        }
    }
    
    private static func throwError(_ error: DatabaseError) throws {
        Telemetry.trackDatabaseError(error)
        throw error
    }
}

// MARK: Public API - Create
extension Database {
    func createFavorite(content: GeneratedWord) async throws {
        try await writeContext.perform {
            let new = Favorite(context: writeContext)
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
            
            try Self.save(writeContext, caller: .createFavorite)
        }
    }
}

// MARK: Public API - Delete
extension Database {
    func deleteFavorite(_ favorite: Favorite) async throws {
        let objectID = favorite.objectID
        let writeContext = self.writeContext
        try await writeContext.perform {
            let object = writeContext.object(with: objectID)
            writeContext.delete(object)
            try Self.save(writeContext, caller: .deleteFavoriteByObject)
        }
    }
    
    func deleteFavorite(_ word: String) async throws {
        let writeContext = self.writeContext
        try await writeContext.perform {
            let request = Favorite.fetchRequest()
            request.predicate = NSPredicate(format: "word ==[c] %@", word)
            
            do {
                for object in try writeContext.fetch(request) {
                    writeContext.delete(object)
                }
            } catch {
                try Self.throwError(DatabaseError(error, operation: .fetch, caller: .deleteFavoriteByString))
            }
            try Self.save(writeContext, caller: .deleteFavoriteByString)
        }
    }
    
    func clearAllFavorites() async throws {
        let context = writeContext
        let readContext = viewContext
        
        try await context.perform {
            let fetchRequest = Favorite.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
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
                try Self.throwError(DatabaseError(error, operation: .execute, caller: .clearAllFavorites))
            }
        }
    }
}

// MARK: Public API - Read
extension Database {
    func getWord(from favorite: Favorite) async -> String? {
        let objectID = favorite.objectID
        let readContext = viewContext
        return await readContext.perform {
            (readContext.object(with: objectID) as? Favorite)?.word
        }
    }
    
    func allFavoriteWordStrings() -> Set<String> {
        let readContext = viewContext
        
        do {
            return try readContext.performAndWait {
                let words = try readContext.fetch(Favorite.fetchRequest()).compactMap(\.word)
                return Set(words)
            }
        } catch {
            print(DatabaseError(error, operation: .fetch, caller: .allFavoriteWordStrings).code)
            Telemetry.trackDatabaseError(DatabaseError(error, operation: .fetch, caller: .allFavoriteWordStrings))
            return []
        }
    }
}

// MARK: Public API - Update
extension Database {
    func rateFavorite(_ favorite: Favorite, rating: Int) async throws {
        let objectID = favorite.objectID
        let writeContext = self.writeContext
        try await writeContext.perform {
            guard let object = writeContext.object(with: objectID) as? Favorite else {
                return try Self.throwError(.makeMissingObject(operation: .object, caller: .rateFavorite))
            }
            object.rating = Int64(rating)
            try Self.save(writeContext, caller: .rateFavorite)
        }
    }
    
}

// MARK: Previews
extension Database {
    static var preview: Database = {
        let controller = Database(inMemory: true)
        let context = controller.container.viewContext

        // Create sample objects
        let mock1 = Favorite(context: context)
        mock1.word = "glunde"
        mock1.dateAdded = Date()
        mock1.actualSyllables = 2
        let mock3 = Favorite(context: context)
        mock3.word = "aja"
        mock3.dateAdded = Date()
        mock3.actualSyllables = 2
        let mock2 = Favorite(context: context)
        mock2.word = "bismustrex"
        mock2.dateAdded = Date()
        mock2.actualSyllables = 3

        do {
            try Database.save(context, caller: .createPreviewDatabase)
        } catch let error as DatabaseError {
            fatalError("Failed to save preview data: \(error.category)")
        } catch {
            fatalError("Failed to save preview data: \(error.localizedDescription)")
        }

        return controller
    }()
}
