//
//  AppDelegate.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        
        self.window?.rootViewController = navigationController
        self.window?.rootViewController?.show(TrackListController(), sender: nil)
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

