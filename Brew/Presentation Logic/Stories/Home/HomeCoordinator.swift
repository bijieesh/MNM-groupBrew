//
//  HomeCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeCoordinator: NavigationCoordinator {
	typealias PlayPodcastAction = (Podcast, Int) -> Void
	
	var onNeedPlayPodcast: PlayPodcastAction?
	private var showsPodcasts: [Podcast] = []

    override func start() {
        super.start()
		
		setupHomeContainer()
    }
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
		let shows = ShowsViewController()
		
		shows.onPodcastPressed = { [weak self] in self?.showPodcastDetails(by: $0) }
		
		loadShowsData(for: shows)
		
		return shows
	}
	
	func createSavedController() -> NewReleaseViewController {
		let newRelease = NewReleaseViewController()
		
		return newRelease
	}
	
	func createHomeController() {
		let newRelease = createNewReleaseController()
		let shows = createShowsController()
		let saved = createSavedController()
		
		let homeContainer = HomeContainerViewController()
		
		homeContainer.controllers = [newRelease, shows, saved]
		
		navigationController?.pushViewController(homeContainer, animated: true)
	}
	
	func showPodcastDetails(for podcast: Podcast) {
		let controller = PodcastDetailViewController()
		controller.podcast = podcast
		
		controller.onBackPressed = { [weak self] in self?.navigationController?.popViewController(animated: true) }
		controller.onEpisodeSelected = { [weak self] in self?.onNeedPlayPodcast?(podcast, $0) }
		
		navigationController?.pushViewController(controller, animated: true)
	}
	
	func showPodcastDetails(by index: Int) {
		let podcast = showsPodcasts[index]
		showPodcastDetails(for: podcast)
	}
}

//MARK: - Server Communication
private extension HomeCoordinator {
	func loadNewReleasesData(for controller: NewReleaseViewController) {
		GetPodcastsRequest(type: .new).execute(onSuccess: { podcasts in
			controller.newReleaseData = podcasts
		})
	}
	
	func loadShowsData(for controller: ShowsViewController) {
		GetPodcastsRequest(type: .all).execute(onSuccess: { [weak self] podcasts in
			self?.showsPodcasts = podcasts
			controller.data = podcasts
		})
	}
}
