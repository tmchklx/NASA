//
//  CoreDataProvider.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import Foundation

import CoreData
import Foundation

final class CoreDataProvider {
    let persistantContainer: NSPersistentContainer

    static let shared = CoreDataProvider()

    var viewContext: NSManagedObjectContext {
        persistantContainer.viewContext
    }

    init() {
        persistantContainer = NSPersistentContainer(name: "NasaSearchHistory")
        persistantContainer.loadPersistentStores { description, error in
            if let error = error {
                Logger.error("Failed to load data from persistant container: \(error)")
            }
        }
    }
}
