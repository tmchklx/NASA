//
//  SearchHistoryViewModel.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import CoreData
import Foundation

final class SearchHistoryTableViewModel {
    var history = [SearchHistoryViewModel]()

    init() {
        let searchHistory: [SearchHistory] = SearchHistory.all().reversed()
        self.history = searchHistory.map(SearchHistoryViewModel.init)
    }

    func clearHistory() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SearchHistory")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try SearchHistory.viewContext.execute(batchDeleteRequest)
            try SearchHistory.viewContext.save()
            history = SearchHistory.all().map(SearchHistoryViewModel.init)
        } catch {
            Logger.error("Failed to delete all objects: \(error)")
            SearchHistory.viewContext.rollback()
        }
    }
}

struct SearchHistoryViewModel: Hashable {
    let historyQuery: SearchHistory

    var rover: Rover {
        guard let roverString = historyQuery.rover else { return .curiosity }

        return Rover(from: roverString)
    }

    var camera: Camera {
        guard let cameraString = historyQuery.camera else { return .all }

        return Camera(from: cameraString)
    }

    var date: String {
        historyQuery.date ?? Date().convertToString
    }

    var isSearchSuccessful: Bool {
        historyQuery.isSearchSuccessful
    }
}
