//
//  MainFlowCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class MainFlowCoordinator: Coordinator {

    override func start() {
        super.start()

        guard let homeController = setupedHomeController() else {
            return
        }

        guard let profileController = setupedProfileController() else {
            return
        }

        let menuCoordinator = MenuCoordinator(rootController: rootController, controllers:
            [
                (.home, homeController),
                (.profile, profileController)
            ])

        menuCoordinator.start()
    }

    private func setupedHomeController() -> UIViewController? {
        let coordinator = HomeCoordinator(rootController: rootController)
        coordinator.start()
        return coordinator.contentController
    }

    private func setupedProfileController() -> UIViewController? {
        let coordinator = ProfileCoordinator(rootController: rootController)
        coordinator.start()
        return coordinator.contentController
    }
}
