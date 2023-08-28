//
//  HomeViewModel.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

final class HomeViewModel {
    var onDataReceived: (() -> Void)?
    var photos: [Photo] = [] {
        didSet {
            onDataReceived?()
        }
    }

    private let dataProvider = NasaDataProvider()
    let cache = NSCache<NSString, UIImage>()
    func fetchData(for endpoint: Endpoint) {
        dataProvider.data(for: endpoint) { [ weak self ]response in
            guard let self = self else {
                Logger.error("Object seems to be already dealocated.")
                return
            }
            
            switch response {
            case .success(let photos):
                Logger.info("Fetched data from api.")
                self.photos = photos
            case .failure(let error):
                Logger.error("Failed to fetch: \(error.localizedDescription)")
            }
        }
    }

    func loadPhoto(from url: URL?, completion: @escaping (UIImage?) -> Void) {
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
