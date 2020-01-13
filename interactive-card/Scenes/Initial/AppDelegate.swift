//
//  AppDelegate.swift
//  interactive-card
//
//  Created by Erik Andresen on 13/01/2020.
//  Copyright © 2020 Shabibi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createViewController()
        return true
    }
    
    private func createViewController() {
        let viewController = MainViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

