//
//  HomeCoordinator.swift
//  Brew
//
//  Created by new user on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {

    private(set) var contentController: UINavigationController?

    override func start() {
        super.start()

        setupHomeController()
    }

    private func setupHomeController() {
        let homeController = HomeViewController()

        homeController.onPodcastSelected = { [weak self] in
            self?.showPodcastDetails(for: $0)
        }

        let contentController = UINavigationController(rootViewController: homeController)
        contentController.isNavigationBarHidden = true
        self.contentController = contentController
        loadHomeContent(for: homeController)
    }

    private func showPodcastDetails(for podcast: Podcast) {
        let controller = PodcastDetailViewController()
        controller.podcast = podcast
        contentController?.pushViewController(controller, animated: true)
    }

    private func loadHomeContent(for controller: HomeViewController) {
        var discoverPodcasts: [Podcast] = []
        var popularPodcasts: [Podcast] = []
        var newPodcasts: [Podcast] = []
        var editorsPodcasts: [Podcast] = []

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        GetPodcastsRequest(type: .discover).execute(onSuccess: {
            discoverPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        GetPodcastsRequest(type: .popular).execute(onSuccess: {
            popularPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        GetPodcastsRequest(type: .new).execute(onSuccess: {
            newPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        GetPodcastsRequest(type: .editors).execute(onSuccess: {
            editorsPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            controller.update(withDiscover: discoverPodcasts, popular: popularPodcasts, new: newPodcasts, editors: editorsPodcasts)
        }
    }
}
