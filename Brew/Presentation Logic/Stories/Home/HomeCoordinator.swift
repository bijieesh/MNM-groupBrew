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
	
	private var newPodcasts: [Podcast] = []
	private var oldPodcasts: [Podcast] = []
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
		loadNewReleasesData(for: newRelease)
		
		newRelease.onPopcastPressed = { [weak self] podcastType, actionType, index in
			self?.handlePodcastType(type: podcastType, action: actionType, index: index)
		}
		
		return newRelease
	}
	
	func handlePodcastType(type: NewReleaseViewController.PodcastType, action: NewReleaseViewController.PodcastActionType, index: Int) {
		switch type {
		case .new:
			let podcast = newPodcasts[index]
			handlePodcastAction(podcast: podcast, action: action)
		case .old:
			let podcast = oldPodcasts[index]
			handlePodcastAction(podcast: podcast, action: action)
		}
	}
	
	func handlePodcastAction(podcast: Podcast, action: NewReleaseViewController.PodcastActionType) {
		switch action {
		case .skip:
			skip(podcast)
		case .load:
			load(podcast)
		}
	}
	
	func createShowsController() -> ShowsViewController {
		let shows = ShowsViewController()
		loadShowsData(for: shows)
		
		shows.onPodcastPressed = { [weak self] in self?.showPodcastDetails(by: $0) }
		
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
	
	func skip(_ podcast: Podcast) {
		
	}
	
	func load(_ podcast: Podcast) {
		
	}
}

//MARK: - Server Communication
private extension HomeCoordinator {
	func loadNewReleasesData(for controller: NewReleaseViewController) {
		GetPodcastsRequest(type: .new).execute(onSuccess: { [weak self] podcasts in
			self?.newPodcasts = podcasts
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
