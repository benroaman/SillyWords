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
    private(set) var initializeFailureError: DatabaseError?
    
    // MARK: Initializers
    init(inMemory: Bool = false) {
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
                let error = DatabaseError(error, operation: .setQueryGenerationFrom, caller: .initializer)
                #if DEBUG
                fatalError(error.category)
                #else
                initializeFailureError = error
                #endif
            }
            
        } else {
            let error = DatabaseError.makeNoPersistentStoreDescription(operation: .persistentStoreDescriptions, caller: .initializer)
            #if DEBUG
            fatalError(error.category)
            #else
            initializeFailureError = error
            #endif
        }
        
        var loadPersistentStoreError: DatabaseError?
        container.loadPersistentStores { storeDescription, error in
            if let error {
                // In production, handle this gracefully (e.g. corrupt store,
                // disk full, no iCloud account). Don't fatalError in shipped code.
                loadPersistentStoreError = DatabaseError(error, operation: .loadPersistentStores, caller: .initializer)
            }
        }
        
        if let loadPersistentStoreError {
            #if DEBUG
            fatalError(loadPersistentStoreError.category)
            #else
            initializeFailureError = loadPersistentStoreError
            #endif
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
            context.rollback()
            try throwError(DatabaseError(error, operation: .save, caller: caller))
        }
    }
    
    private static func throwError(_ error: DatabaseError) throws {
        Telemetry.trackDatabaseError(error)
        throw error
    }
    
    private func confirmInitialization() throws {
        if let initializeFailureError {
            throw initializeFailureError
        }
    }
}

// MARK: Public API - Create
extension Database {
    private static var favoritesPredicate: NSPredicate { NSPredicate(format: "isFavorite == YES") }
    private static var nonFavoritesPredicate: NSPredicate { NSPredicate(format: "isFavorite == NO OR isFavorite == nil") }
    private static var textMatchPredicateFormat: String { "text ==[c] %@" }
    
    func createWord(content: GeneratedWord) async throws {
        try confirmInitialization()
        try await writeContext.perform {
            let new = Word(context: writeContext)
            new.text = content.word
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
            new.isFavorite = false
            
            try Self.save(writeContext, caller: .createWord)
        }
    }
}

// MARK: Public API - Delete
extension Database {
    func addFavorite(_ word: Word) async throws {
        try await setIsFavorite(true, for: word)
    }
    
    func addFavorite(_ text: String) async throws {
        try await setIsFavorite(true, for: text)
    }
    
    func removeFavorite(_ word: Word) async throws {
        try await setIsFavorite(false, for: word)
    }
    
    func removeFavorite(_ text: String) async throws {
        try await setIsFavorite(false, for: text)
    }
    
    private func setIsFavorite(_ isFavorite: Bool, for word: Word) async throws {
        try confirmInitialization()
        let objectID = word.objectID
        let writeContext = self.writeContext
        let caller: DatabaseError.Caller = isFavorite ? .addFavoriteByObject : .removeFavoriteByObject
        try await writeContext.perform {
            guard let object = writeContext.object(with: objectID) as? Word else {
                throw DatabaseError.makeMissingObject(operation: .object, caller: caller)
            }
            object.isFavorite = isFavorite
            try Self.save(writeContext, caller: caller)
        }
    }
    
    func setIsFavorite(_ isFavorite: Bool, for text: String) async throws {
        try confirmInitialization()
        let writeContext = self.writeContext
        let caller: DatabaseError.Caller = isFavorite ? .addFavoriteByText : .removeFavoriteByText
        try await writeContext.perform {
            let request = Word.fetchRequest()
            request.predicate = NSPredicate(format: Self.textMatchPredicateFormat, text)
            
            do {
                for word in try writeContext.fetch(request) {
                    word.isFavorite = isFavorite
                }
                try Self.save(writeContext, caller: caller)
            } catch let error as DatabaseError {
                // save only throws a database error
                try Self.throwError(error)
            } catch {
                // so if it's not a database error, it's a fetch error
                try Self.throwError(DatabaseError(error, operation: .fetch, caller: caller))
            }
        }
    }
    
    func deleteWord(_ word: Word) async throws {
        try confirmInitialization()
        let objectID = word.objectID
        let writeContext = self.writeContext
        try await writeContext.perform {
            let object = writeContext.object(with: objectID)
            writeContext.delete(object)
            try Self.save(writeContext, caller: .deleteWordByObject)
        }
    }
    
    func deleteWord(_ text: String) async throws {
        try confirmInitialization()
        let writeContext = self.writeContext
        try await writeContext.perform {
            let request = Word.fetchRequest()
            request.predicate = NSPredicate(format: Self.textMatchPredicateFormat, text)
            
            do {
                for object in try writeContext.fetch(request) {
                    writeContext.delete(object)
                }
                try Self.save(writeContext, caller: .deleteWordByText)
            } catch let error as DatabaseError {
                try Self.throwError(error)
            } catch {
                try Self.throwError(DatabaseError(error, operation: .fetch, caller: .deleteWordByText))
            }
        }
    }
    
    func removeAllFavorites() async throws {
        try confirmInitialization()
        let context = writeContext
        
        try await context.perform {
            let fetchRequest = Word.fetchRequest()
            fetchRequest.predicate = Self.favoritesPredicate
            
            do {
                for word in try context.fetch(fetchRequest) {
                    word.isFavorite = false
                }
                try Self.save(context, caller: .removeAllFavorites)
            } catch let error as DatabaseError {
                try Self.throwError(error)
            } catch {
                try Self.throwError(DatabaseError(error, operation: .execute, caller: .removeAllFavorites))
            }
        }
    }
    
    func deleteWordHistory() async throws {
        try confirmInitialization()
        let write = writeContext
        let read = viewContext
        
        try await write.perform {
            let fetchRequest = Word.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            fetchRequest.predicate = Self.nonFavoritesPredicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try write.execute(deleteRequest) as? NSBatchDeleteResult
                let deletedObjectIDs = result?.result as? [NSManagedObjectID] ?? []
                
                let changes = [NSDeletedObjectsKey: deletedObjectIDs]
                
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [read]
                )
            } catch {
                try Self.throwError(DatabaseError(error, operation: .execute, caller: .deleteWordHistory))
            }
        }
    }
}

// MARK: Public API - Read
extension Database {
    func getText(from word: Word) async throws -> String? {
        try confirmInitialization()
        let objectID = word.objectID
        let readContext = viewContext
        return await readContext.perform {
            (readContext.object(with: objectID) as? Favorite)?.word
        }
    }
    
    func allFavoriteWordStrings() throws -> Set<String> {
        try confirmInitialization()
        let readContext = viewContext
        
        do {
            return try readContext.performAndWait {
                let request = Word.fetchRequest()
                request.predicate = Self.favoritesPredicate
                let words = try readContext.fetch(Word.fetchRequest()).compactMap(\.text)
                return Set(words)
            }
        } catch {
            print(DatabaseError(error, operation: .fetch, caller: .allFavoriteWordStrings).identity.code)
            Telemetry.trackDatabaseError(DatabaseError(error, operation: .fetch, caller: .allFavoriteWordStrings))
            return []
        }
    }
}

// MARK: Public API - Update
extension Database {
    func rateWord(_ word: Word, rating: Int) async throws {
        try confirmInitialization()
        let objectID = word.objectID
        let writeContext = self.writeContext
        try await writeContext.perform {
            guard let object = writeContext.object(with: objectID) as? Favorite else {
                return try Self.throwError(.makeMissingObject(operation: .object, caller: .rateWord))
            }
            object.rating = Int64(rating)
            try Self.save(writeContext, caller: .rateWord)
        }
    }
    
}

// MARK: Previews
extension Database {
    static var preview: Database = {
        let controller = Database(inMemory: true)
        let context = controller.container.viewContext

        // Create sample objects
        let mock1 = Word(context: context)
        mock1.text = "glunde"
        mock1.dateAdded = Date()
        mock1.actualSyllables = 2
        mock1.isFavorite = true
        let mock2 = Word(context: context)
        mock2.text = "bismustrex"
        mock2.dateAdded = Date()
        mock2.actualSyllables = 3
        mock2.isFavorite = true
        let mock3 = Word(context: context)
        mock3.text = "aja"
        mock3.dateAdded = Date()
        mock3.actualSyllables = 2
        mock3.isFavorite = true

        do {
            try Database.save(context, caller: .seedPreviewDatabase)
        } catch let error as DatabaseError {
            fatalError("Failed to save preview data: \(error.category) \(error.identity.code)")
        } catch {
            fatalError("Failed to save preview data: \(error.localizedDescription)")
        }

        return controller
    }()
}
