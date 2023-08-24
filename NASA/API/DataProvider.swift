//
//  DataProvider.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation

protocol DataProvider {
    func data(for endpoint: Endpoint, body: Data?, httpMethod: HTTPMethod) async throws -> Data
}

enum DataProviderError: Error {
    case noDataReceived
    case invalidURL
}
