//
//  NasaDataProvider.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation

enum DataProviderError: Error {
    case noDataReceived
    case invalidURL
    case failedToDecode
    case invalidData

}

final class NasaDataProvider {
    func data(
        for endpoint: Endpoint,
        completion: @escaping (Result<[Photo], DataProviderError>) -> Void) {
            guard let url = endpoint.url() else {
                completion(.failure(.invalidURL))
                return
            }

            fetchData(from: url) { [ weak self ] response in
                guard let self = self else {
                    Logger.error("Object seems to be already dealocated.")
                    return
                }

                switch response {
                case .success(let data):
                    do {
                        let nasaDecodedData = try self.decodeAPIResponse(data)
                        guard let safeNasaDecodedData = nasaDecodedData else {
                            completion(.failure(.invalidData))
                            return
                        }

                        completion(.success(safeNasaDecodedData))
                    } catch { }
                case .failure(_):
                    completion(.failure(.noDataReceived))
                }
            }
        }

    private func fetchData(from url: URL, completion: @escaping (Result<Data, DataProviderError>) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        session.downloadTask(with: url) { fileURL, _, error in
            if error != nil {
                completion(.failure(.noDataReceived))
            }

            guard let url = fileURL, let data = try? Data(contentsOf: url) else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }.resume()
    }

    private func decodeAPIResponse(_ data: Data) throws -> [Photo]? {
        do {
            let decoder = JSONCoder()
            let nasaData = try decoder.decode(type: Nasa.self, from: data)

            if let photos = nasaData.photos {
                return photos
            } else if let latestPhotos = nasaData.latestPhotos {
                return latestPhotos
            } else {
                return nil
            }

        } catch {
            throw DataProviderError.failedToDecode
        }

    }
}
