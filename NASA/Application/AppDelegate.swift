//
//  AppDelegate.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        let homeViewController = HomeViewController()
        let navViewController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navViewController
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }


}

