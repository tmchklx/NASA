//
//  RequestDataModel.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/27/23.
//

import UIKit

class RequestDataModel {
    var date: String
    var rover: Rover
    var camera: Camera
    var isSearchSuccessful: Bool

    var generatedEndpoint: Endpoint {
        if camera == .all {
            return Endpoint.allRoversCameras(rover: rover, date: date)
        } else {
            return Endpoint.specificCamera(rover: rover, camera: camera, date: date)
        }
    }

    init(
        rover: Rover = .curiosity,
        camera: Camera = .all,
        date: String = Date().convertToString,
        isSearchSuccessful: Bool = false
    ) {
        self.rover = rover
        self.camera = camera
        self.date = date
        self.isSearchSuccessful = isSearchSuccessful
    }
}
