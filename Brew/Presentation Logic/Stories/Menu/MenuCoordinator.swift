//
//  MenuCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class MenuCoordinator: Coordinator {
    enum Option: Int {
        case home, profile
    }

    private let controllers: [(option: Option, controller: UIViewController)]

    init(controllers: [(Option, UIViewController)]) {
        self.controllers = controllers
        let tabBarController = MenuCoordinator.setupedTabBarController(for: controllers)
        super.init(contentController: tabBarController)
    }

    private static func setupedTabBarController(for controllers: [(option: Option, controller: UIViewController)]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers.sorted(by: { $0.option.rawValue < $1.option.rawValue }).map({ $0.controller })
        return tabBarController
    }
}
