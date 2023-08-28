//
//  PersistantSettings.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/27/23.
//

import Foundation

final class PersistantSettings {
    static let shared = PersistantSettings()

    var date: String = Date().convertToString
    var rover: Rover = .curiosity
    var camera: Camera = .all

    var roverIndex: Int {
        return Rover.allCases.firstIndex(of: rover) ?? 0
    }

    var cameraIndex: Int {
        return Camera.allCases.firstIndex(of: camera) ?? 0
    }
}
