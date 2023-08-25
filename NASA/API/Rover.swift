////
////  Rover.swift
////  NASA
////
////  Created by Oleksandr Tymchenko on 8/24/23.
////
//
//import Foundation
//
enum Rover: String, CaseIterable {
    case curiosity
    case opportunity
    case spirit

    var allItems: [String] {
        var array: [String] = []
        for item in Self.allCases {
            array.append(item.rawValue)
        }
        return array
    }

    static let itemCount: Int = {
        Self.allCases.count
    }()
}

enum Camera: String, CaseIterable {
    case fhaz
    case rhaz
    case mast
    case chemcam
    case mahli
    case mardi
    case navcam
    case pancam
    case minites

    var allItems: [String] {
        var array: [String] = []
        for item in Self.allCases {
            array.append(item.rawValue)
        }
        return array
    }

    static let itemCount: Int = {
        Self.allCases.count
    }()
}

protocol EnumForCollection {
    var allItems: [String] { get }
    var itemCount: Int {  get }
}
