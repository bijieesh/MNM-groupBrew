//
//  MainFlowCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class MainFlowCoordinator: Coordinator {

    var onLogout: (() -> Void)?

    override func start() {
        super.start()
        setupMenuCoordinator()
    }

    private func setupMenuCoordinator() {
        guard let homeController = setupedHomeController() else {
            return
        }

        guard let profileController = setupedProfileController() else {
            return
        }

        let menuCoordinator = MenuCoordinator(controllers:
            [
                (.home, homeController),
                (.profile, profileController)
            ])

        contentController.present(menuCoordinator.contentController, animated: false)
    }

    private func setupedHomeController() -> UIViewController? {
        let coordinator = HomeCoordinator()
        coordinator.start()
        return coordinator.contentController
    }

    private func setupedProfileController() -> UIViewController? {
        let coordinator = ProfileCoordinator()

        coordinator.onLogout = { [weak self] in
            self?.onLogout?()
        }

        coordinator.start()
        return coordinator.contentController
    }
}
