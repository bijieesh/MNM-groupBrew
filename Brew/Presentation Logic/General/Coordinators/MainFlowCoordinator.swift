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

    private var activeMenuCoordinator: MenuCoordinator?

    private lazy var playerCoordinator: PlayerCoordinator = {
        return PlayerCoordinator(playerContainer: self)
    }()

    override func start() {
        super.start()
        setupMenuCoordinator()
    }

    private func setupMenuCoordinator() {
        guard let homeController = setupedHomeController() else {
            return
        }

		guard let searchController = setupedSearchController() else {
			return
		}
		
        guard let profileController = setupedProfileController() else {
            return
        }

        let menuCoordinator = MenuCoordinator(controllers:
            [
                (.home, homeController),
				(.search, searchController),
				(.profile, profileController)
            ])

        activeMenuCoordinator = menuCoordinator
        contentController.present(menuCoordinator.contentController, animated: false)
    }

    private func playPodcast(_ podcast: Podcast, from index: Int) {
        playerCoordinator.playEpisode(at: index, from: podcast)
    }

    private func setupedHomeController() -> UIViewController? {
        let coordinator = HomeCoordinator()

        coordinator.onNeedPlayPodcast = { [weak self] in
            self?.playPodcast($0, from: $1)
        }

        coordinator.start()
        return coordinator.contentController
    }
	
	private func setupedSearchController() -> UIViewController? {
		let coordinator = SearchCoordinator()
		
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

extension MainFlowCoordinator: PlayerContainer {

    func presentMiniPlayer(_ player: AppViewController) {
        activeMenuCoordinator?.addMiniPlayer(player)
    }

    func presentFullScreenPlayer(_ player: AppViewController) {
        player.onClose = { [weak player] in
            player?.dismiss(animated: true)
        }

        contentController.topController.present(player, animated: true)
    }
}
