//
//  SettingsViewController.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

class SettingsViewController: UIViewController {
    let settingsView = SettingsViewControllerView()
    var completionHandler: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        view = settingsView
        settingsView.applySelectionButton.addTarget(self, action: #selector(applySettings), for: .touchUpInside)
    }

    @objc func applySettings() {
        completionHandler?(
            Rover.allCases[settingsView.indexOfSelectedRover.row].rawValue,
            Camera.allCases[settingsView.indexOfSelectedCamera.row].rawValue
        )
        
        dismiss(animated: true)
    }
}
