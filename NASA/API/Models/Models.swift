//
//  Endpoint.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation

// MARK: - Nasa
struct Nasa: Codable {
    let photos: [Photo]?
    let latestPhotos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case photos
        case latestPhotos = "latest_photos"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photos = try container.decodeIfPresent([Photo].self, forKey: .photos)
        self.latestPhotos = try container.decodeIfPresent([Photo].self, forKey: .latestPhotos)
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id: Int
    let imgSrc: String

    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
    }
}

protocol Enumeratable: CaseIterable where Self: RawRepresentable {
    associatedtype T
    var allItems: [T] { get }
    static var itemCount: Int { get }
}

extension Enumeratable {
    var allItems: [T] {
        return Self.allCases.map {$0.rawValue as! Self.T}
    }

    static var itemCount: Int {
        allCases.count
    }
}

enum Rover: String, CaseIterable, Enumeratable {
    typealias T = String

    case curiosity
    case opportunity
    case spirit
}

enum Camera: String, CaseIterable, Enumeratable {
    typealias T = String

    case all = "All cameras"
    case fhaz
    case rhaz
    case mast
    case chemcam
    case mahli
    case mardi
    case navcam
    case pancam
    case minites
}
