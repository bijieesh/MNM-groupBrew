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
        tabBarController.tabBar.tintColor = .appOrange

        controllers.first(where: { $0.option == .home })?.controller.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_bar_home"), selectedImage: UIImage(named: "tab_bar_home_selected"))
        controllers.first(where: { $0.option == .profile })?.controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tab_bar_profile"), selectedImage: UIImage(named: "tab_bar_profile_selected"))

        tabBarController.viewControllers = controllers.sorted(by: { $0.option.rawValue < $1.option.rawValue }).map({ $0.controller })
        return tabBarController
    }
}
