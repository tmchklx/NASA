//
//  Endpoint.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation

enum Endpoint {
    static let baseURL = "https://api.nasa.gov/mars-photos"
    static let apiKey = "9glLVLOzpJabphxgQ8YHpXYx5bBAoT7XXhzlkgQM"

    case allRoversCameras(rover: Rover, date: String)
    case specificCamera(rover: Rover, camera: Camera, date: String)
    case latestPhotos(rover: Rover)

    private var endpointURL: String {
        switch self {
        case .allRoversCameras:
            return "/api/v1/rovers/[rover]/photos?earth_date=[date]&api_key=[key]"
        case .specificCamera:
            return "/api/v1/rovers/[rover]/photos?earth_date=[date]&camera=[camera]&api_key=[key]"
        case .latestPhotos:
            return "/api/v1/rovers/[rover]/latest_photos?api_key=[key]"
        }
    }

    func url() -> URL? {
        var path: String = endpointURL
        path = path.replacingOccurrences(of: "[key]", with: Self.apiKey)

        switch self {
        case .allRoversCameras(let rover, let date):
            path = path.replacingOccurrences(of: "[rover]", with: rover.rawValue)
            path = path.replacingOccurrences(of: "[date]", with: date)
        case .specificCamera(let rover, let camera, let date):
            path = path.replacingOccurrences(of: "[rover]", with: rover.rawValue)
            path = path.replacingOccurrences(of: "[date]", with: date)
            path = path.replacingOccurrences(of: "[camera]", with: camera.rawValue)
        case .latestPhotos(let rover):
            path = path.replacingOccurrences(of: "[rover]", with: rover.rawValue)
        }

        return URL(string: "\(Self.baseURL)\(path)")
    }
}
