//
//  SettingsViewViewModel.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/27/23.
//

import UIKit

class SettingViewViewModel {
    var date: String = PersistantSettings.shared.date
    var rover: Rover = PersistantSettings.shared.rover
    var camera: Camera = PersistantSettings.shared.camera

    var generatedEndpoint: Endpoint {
        if camera == .all {
            return Endpoint.allRoversCameras(rover: rover, date: date)
        } else {
            return Endpoint.specificCamera(rover: rover, camera: camera, date: date)
        }
    }

    init(rover: Rover = .curiosity, camera: Camera = .all) {
        self.rover = rover
        self.camera = camera
    }
}
