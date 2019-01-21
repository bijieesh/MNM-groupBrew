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

        let vc = AppViewController()

        vc.view.backgroundColor = .white

        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        let c = AppFlowCoordinator(rootController: vc)
        c.start()

        return true
    }
}

