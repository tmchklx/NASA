//
//  NasaDataProvider.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation
//
//final class NasaDataProvider {
//    func data(for endpoint: Endpoint, rover: String?, date: String?, httpMethod: HTTPMethod) async throws -> [Photo] {
//        guard let rover = rover, let date = date else { throw DataProviderError.noDataReceived }
//        var request = URLRequest(url: try endpoint.url(forRover: rover, on: date))
//    }
//
//    private func fetchData(url: URL, body: Data? = nil, httpMethod: HTTPMethod = .get, accessToken: String)
//        async throws -> Data
//    {
//        var request = URLRequest(url: url)
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        let statusCodeUnauthorized = 401
//        if let httpResponse = response as? HTTPURLResponse,
//            httpResponse.statusCode == statusCodeUnauthorized
//        {
//            Logger.info("Received HTTP response 401, assuming we've been logged out.")
//            loginInfo = nil
//        }
//
//        return data
//    }
//
//
//}

