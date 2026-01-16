//
//  CoreDataManager.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/12/25.
//

import CoreData

import Foundation


//
//final class CoreDataManager {
//
//    static let shared = CoreDataManager()
//
//    let container: NSPersistentContainer
//
//    private init() {
//        container = NSPersistentContainer(name: "AppCoreDataModel")
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Core Data error: \(error)")
//            }
//        }
//
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//
//    /// ✅ Single source of truth for SwiftUI
//    var context: NSManagedObjectContext {
//        container.viewContext
//    }
//}


import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "AppCoreDataModel")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Core Data Error: \(error)") // In Prod: Log to Crashlytics
            }
        }
        
        // CRITICAL: Automatically update UI when background saves happen
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // CRITICAL: Handle conflicts (e.g. if ID exists, overwrite it)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    /// ✅ Single source of truth for SwiftUI
       var context: NSManagedObjectContext {
           container.viewContext
       }

    /// Perform heavy database writes on a background thread
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            
            // Save inside the background context
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("❌ Background Save Error: \(error)")
                }
            }
        }
    }
}
