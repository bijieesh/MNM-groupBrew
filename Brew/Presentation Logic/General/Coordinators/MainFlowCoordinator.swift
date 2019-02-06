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

    private let playerCoordinator = PlayerCoordinator()
    private var activeMenuCoordinator: MenuCoordinator?

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

        activeMenuCoordinator = menuCoordinator
        contentController.present(menuCoordinator.contentController, animated: false)
    }

    private func playPodcast(_ podcast: Podcast, from index: Int) {
        guard let data = playerCoordinator.playEpisode(at: index, from: podcast) else {
            return
        }

        data.controller.onClose = {
            data.controller.dismiss(animated: true)
        }

        activeMenuCoordinator?.addMiniPlayer(data.miniController)
        contentController.topController.present(data.controller, animated: true)
    }

    private func setupedHomeController() -> UIViewController? {
        let coordinator = HomeCoordinator()

        coordinator.onNeedPlayPodcast = { [weak self] in
            self?.playPodcast($0, from: $1)
        }

        coordinator.start()
        return coordinator.contentController
    }

    private func setupedProfileController() -> UIViewController? {
        let coordinator = ProfileCoordinator()

        coordinator.onLogout = { [weak self] in
            self?.onLogout?()
        }

        coordinator.onNeedPlayPodcast = { [weak self] in
            self?.playPodcast($0, from: $1)
        }

        coordinator.start()
        return coordinator.contentController
    }
}
