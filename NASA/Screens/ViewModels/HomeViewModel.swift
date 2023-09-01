//
//  HomeViewModel.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

final class HomeViewModel {
    private var nasaData: [Photo] = [] {
        didSet {
            if oldValue != nasaData {
                onDataReceived?(didFetchNasaData)
            }
        }
    }

    private var hasEnoughPhotosForFullPage: Bool {
        if nasaData.count >= 20 * (currentPage + 1) {
            return true
        } else {
            return false
        }
    }

    private var currentPhotoIndex: ClosedRange<Int> {
        guard !nasaData.isEmpty else { return 0...0 }
        let firstIndex = currentPage * 20
        let endIndex = hasEnoughPhotosForFullPage ? (firstIndex + 19): (nasaData.count - 1)
        return firstIndex...endIndex
    }

    private let dataProvider = NasaDataProvider()

    var onDataReceived: ((Bool) -> Void)?
    var currentPage = 0
    var photos: [UIImage] = []
    var didFetchNasaData = false
    let cache = NSCache<NSString, UIImage>()

    func saveSearchToDataBase(with model: RequestDataModel) {
        let query = SearchHistory(context: SearchHistory.viewContext)
        query.rover = model.rover.rawValue
        query.camera = model.camera.rawValue
        query.date = model.date
        query.isSearchSuccessful = model.isSearchSuccessful
        query.save()
    }

    func fetchURLString(for index: Int) -> String {
        return nasaData[index].imgSrc
    }
    
    func fetchData(for endpoint: Endpoint, completion: @escaping () -> Void) {
        didFetchNasaData = false
        currentPage = 0
        dataProvider.data(for: endpoint) { [ weak self ] response in
            guard let self = self else {
                self?.didFetchNasaData = false
                Logger.error("Object seems to be already dealocated.")
                return
            }
            
            switch response {
            case .success(let photos):
                Logger.info("Fetched data from api.")
                if !photos.isEmpty {
                    self.didFetchNasaData = true
                }

                self.nasaData = photos
                self.photos = []
                completion()
            case .failure(let error):
                self.didFetchNasaData = false
                Logger.error("Failed to fetch: \(error.localizedDescription)")
            }
        }
    }

    func loadBatch(completion: @escaping () -> Void) {
        let group = DispatchGroup()

        guard !nasaData.isEmpty else {
            completion()
            return
        }
        for index in currentPhotoIndex {
            let url = URL(string: nasaData[index].imgSrc)
            group.enter()
            loadPhoto(from: url) { image in
                guard let image = image else { return }

                self.photos.append(image)
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.global()) {
            if self.photos.count == self.currentPhotoIndex.upperBound + 1 {
                self.currentPage += 1
            }

            sleep(2)
            completion()
        }

    }

    private func loadPhoto(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else { return }

        if let image = cache.object(forKey: NSString(string: url.absoluteString)) {
            completion(image)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [ weak self ] data, _, error in
            guard let self = self else {
                Logger.error("Object seems to be already dealocated.")
                return
            }

            guard let data = data, error == nil else {
                completion(nil)
                Logger.error("Failed to download photo.")
                return
            }

            if let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: NSString(string: url.absoluteString))
                completion(image)
            } else {
                Logger.error("Could not initialize UIImage from data")
                completion(nil)
            }
        }
        task.resume()
    }
}
