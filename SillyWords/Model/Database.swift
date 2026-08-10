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

struct Database {

    static let shared = Database()

    let container: NSPersistentCloudKitContainer

    init() {
        // Name must match your .xcdatamodeld filename
        container = NSPersistentCloudKitContainer(name: "SillyWords")

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
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main
        ) { _ in
            print("Remote change detected from CloudKit")
        }
    }

    // Convenience save with error handling
    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Save failed: \(nsError), \(nsError.userInfo)")
        }
    }
}
