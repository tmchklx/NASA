//
//  Endpoint.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum Endpoint: String {
    static let baseURL = "https://api.nasa.gov/mars-photos"
    static let apiKey = "9glLVLOzpJabphxgQ8YHpXYx5bBAoT7XXhzlkgQM"

    case earthDate = "/api/v1/rovers/[rover]/photos?earth_date=[date]&api_key=[key]"
    case sol = "/api/v1/rovers/[rover]/photos?sol=[date]&api_key=[key]"

    func url(forRover rover: String, on date: String) throws -> URL {
        var path: String = rawValue
        path = path.replacingOccurrences(of: "[rover]", with: rover)
        path = path.replacingOccurrences(of: "[date]", with: date)
        path = path.replacingOccurrences(of: "[key]", with: Self.apiKey)

        guard let url = URL(string: "\(Self.baseURL)\(path)") else {
            Logger.error("Failed to compose url for the api.")
            throw DataProviderError.invalidURL
        }

        return url
    }
}
