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

    private var appFlowCoordinator: AppFlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let vc = PodcastDetailViewController()

        vc.view.backgroundColor = .white

        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        //appFlowCoordinator = AppFlowCoordinator(rootController: vc)
        //appFlowCoordinator?.start()

        return true
    }
}

