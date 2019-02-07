//
//  HomeCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeCoordinator: NavigationCoordinator {

    var onNeedPlayPodcast: ((Podcast, Int) -> Void)?

    override func start() {
        super.start()
		
		setupHomeContainer()
    }
	
	
    private func showPodcastDetails(for podcast: Podcast) {
        let controller = PodcastDetailViewController()
        controller.podcast = podcast

        controller.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        controller.onEpisodeSelected = { [weak self] index in
            self?.onNeedPlayPodcast?(podcast, index)
        }

        navigationController?.pushViewController(controller, animated: true)
    }

//    private func loadHomeContent(for controller: HomeViewController) {
//        var discoverPodcasts: [Podcast] = []
//        var popularPodcasts: [Podcast] = []
//        var newPodcasts: [Podcast] = []
//        var editorsPodcasts: [Podcast] = []
//
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        GetPodcastsRequest(type: .discover).execute(onSuccess: {
//            discoverPodcasts = $0
//            dispatchGroup.leave()
//        })
//
//        dispatchGroup.enter()
//        GetPodcastsRequest(type: .popular).execute(onSuccess: {
//            popularPodcasts = $0
//            dispatchGroup.leave()
//        })
//
//        dispatchGroup.enter()
//        GetPodcastsRequest(type: .new).execute(onSuccess: {
//            newPodcasts = $0
//            dispatchGroup.leave()
//        })
//
//        dispatchGroup.notify(queue: .main) {
//            controller.update(withDiscover: discoverPodcasts, popular: popularPodcasts, new: newPodcasts, editors: editorsPodcasts)
//        }
//    }
}

private extension HomeCoordinator {
	func setupHomeContainer() {
		createHomeController()
	}
	
	func createNewReleaseController() -> NewReleaseViewController {
		let newRelease = NewReleaseViewController()
		
		return newRelease
	}
	
	func createShowsController() -> ShowsViewController {
		return ShowsViewController()
	}
	
	func createSavedController() -> UIViewController {
		return UIViewController()
	}
	
	func createHomeController() {
		let newRelease = createNewReleaseController()
		let shows = createShowsController()
		let saved = createSavedController()
		
		let homeContainer = HomeContainerViewController()
		
		homeContainer.controllers = [newRelease, shows, saved]
		
		navigationController?.pushViewController(homeContainer, animated: true)
	}
}
