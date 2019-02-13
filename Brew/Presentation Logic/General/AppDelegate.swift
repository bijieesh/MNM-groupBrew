//
//  AppDelegate.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/17/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let appFlowCoordinator = AppFlowCoordinator()

        window?.rootViewController = appFlowCoordinator.contentController
        window?.makeKeyAndVisible()

        appFlowCoordinator.start()

        application.setMinimumBackgroundFetchInterval(30)

        return true
    }
}

