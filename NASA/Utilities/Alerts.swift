//
//  Alerts.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 9/1/23.
//

import UIKit

struct Alerts {
    private static func showBasicAlert(on vc: UIViewController, withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }

    static func showNoPhotosFetchedAlert(on vc: UIViewController) {
        Alerts.showBasicAlert(on: vc, withTitle: "No Data Received", message: "Seems that selected rover didn't take any pictures with selected options. Try to choose different configuration.")
    }

    static func showUnseccessfulSearch(on vc: UIViewController) {
        Alerts.showBasicAlert(on: vc, withTitle: "No Data Received", message: "Rover didn't take any photos with selected options.")
    }
}
