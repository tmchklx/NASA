//
//  BaseCoreDataModel.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import CoreData
import Foundation

protocol BaseCoreDataModel: NSManagedObject {
    func save()
    func delete()
    static func all<T>() -> [T] where T: NSManagedObject
    static func byID<T>(_ id: NSManagedObjectID) -> T? where T: NSManagedObject
}

extension BaseCoreDataModel {
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.viewContext
    }

    func save() {
        do {
            try Self.viewContext.save()
        } catch {
            Self.viewContext.rollback()
            Logger.error("Failed to save new context: \(error)")
        }
    }

    func delete() {
        Self.viewContext.delete(self)
        save()
    }

    static func all<T>() -> [T] where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))

        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            Logger.error("Failed to fetch all objects: \(error)")
            return []
        }
    }

    static func byID<T>(_ id: NSManagedObjectID) -> T? where T: NSManagedObject {
        do {
            return try viewContext.existingObject(with: id) as? T
        } catch {
            Logger.error("Failed to fetch object by id: \(error)")
            return nil
        }
    }
}

