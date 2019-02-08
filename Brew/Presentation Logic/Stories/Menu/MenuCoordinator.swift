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
        case home, search, profile
    }

    private let controllers: [(option: Option, controller: UIViewController)]
	
	let containerController: MenuContainerViewController!

    init(controllers: [(Option, UIViewController)]) {
        self.controllers = controllers
		
		containerController = MenuCoordinator.setupContainerController(for: controllers)
		
		super.init(contentController: containerController)
    }

    func addMiniPlayer(_ miniPlayer: UIViewController) {
        guard let playerContainer = containerController?.playerContainer else {
            return
        }

		miniPlayer.willMove(toParent: containerController)
		containerController.showPlayerView = true
        playerContainer.addSubview(miniPlayer.view)
        miniPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.view.widthAnchor.constraint(equalTo: playerContainer.widthAnchor).isActive = true
        miniPlayer.view.centerXAnchor.constraint(equalTo: playerContainer.centerXAnchor).isActive = true
		miniPlayer.view.heightAnchor.constraint(equalTo: playerContainer.heightAnchor).isActive = true
		miniPlayer.view.centerYAnchor.constraint(equalTo: playerContainer.centerYAnchor).isActive = true
		
        miniPlayer.didMove(toParent: containerController)
    }

	private static func setupContainerController(for controllers: [(option: Option, controller: UIViewController)]) -> MenuContainerViewController {
		controllers.first(where: { $0.option == .home })?.controller.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_bar_home"), selectedImage: UIImage(named: "tab_bar_home_selected"))
		controllers.first(where: { $0.option == .search })?.controller.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "tab_bar_search"), selectedImage: UIImage(named: "tab_bar_search_selected"))
		controllers.first(where: { $0.option == .profile })?.controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tab_bar_profile"), selectedImage: UIImage(named: "tab_bar_profile_selected"))
		
		let controllers = controllers.sorted(by: { $0.option.rawValue < $1.option.rawValue }).map({ $0.controller })
		
		let containerController = MenuContainerViewController(controllers: controllers)
		
		return containerController
	}
}
