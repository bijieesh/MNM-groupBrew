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
		tabBarController.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		
        super.init(contentController: tabBarController)
    }

    func addMiniPlayer(_ miniPlayer: UIViewController) {
        guard let tabBarCntroller = contentController as? UITabBarController else {
            return
        }

        miniPlayer.willMove(toParent: tabBarCntroller)
		
        tabBarCntroller.view.addSubview(miniPlayer.view)
        miniPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.view.widthAnchor.constraint(equalTo: tabBarCntroller.view.widthAnchor).isActive = true
        miniPlayer.view.centerXAnchor.constraint(equalTo: tabBarCntroller.view.centerXAnchor).isActive = true
        miniPlayer.view.bottomAnchor.constraint(equalTo: tabBarCntroller.view.bottomAnchor, constant: -tabBarCntroller.tabBar.bounds.height).isActive = true

        miniPlayer.didMove(toParent: tabBarCntroller)
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
