//
//  HomeViewController.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var homeScreenView = HomeViewControllerView()
    var rover: String = ""
    var camera: String = ""

    override func loadView() {
        view = homeScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeScreenView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }

    @objc private func settingsButtonTapped() {
        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .currentContext
        settingsViewController.completionHandler = { rover, camera in
            Logger.debug(rover)
            Logger.debug(camera)
        }
        
        present(settingsViewController, animated: true)
    }
}

