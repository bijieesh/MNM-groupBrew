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

    override func start() {
        super.start()
		
		setupHomeContainer()
    }
}

//MARK: - Controller Presentation
private extension HomeCoordinator {
	func setupHomeContainer() {
		createHomeController()
	}
	
	func createNewReleaseController() -> EpisodesViewController {
		let newReleaseVC = EpisodesViewController()
		newReleaseVC.controllerType = .new
		
		newReleaseVC.onPodcastPressed = { podcast, actionType in
			
		}
		
		loadNewReleasesData(for: newReleaseVC)
		
		return newReleaseVC
	}
	
	func createShowsController() -> ShowsViewController {
		let showsVC = ShowsViewController()
		loadShowsData(for: showsVC)
		showsVC.back = true
		
		showsVC.onPodcastPressed = { index in
			
		}
		
		return showsVC
	}
	
	func createSavedController() -> EpisodesViewController {
		let savedVC = EpisodesViewController()
		savedVC.controllerType = .saved
		
		savedVC.onPodcastPressed = { podcast, actionType in
			
		}
		
		loadSavedEpisodes(for: savedVC)
		
		return savedVC
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
}

//MARK: - Action Handlers
private extension HomeCoordinator {
	func save(_ episode: Episode) {
		saveEpisode(by: episode.id)
	}
	
	func delete(_ episode: Episode) {
		
	}
	
	func select(_ episode: Episode) {
		
	}
}

//MARK: - Server Communication
private extension HomeCoordinator {
	func loadNewReleasesData(for controller: EpisodesViewController) {
        GetNewReleasesRequest().execute(onSuccess: { episodes in
			controller.topData = episodes
        })
	}
	
	func loadShowsData(for controller: ShowsViewController) {
		GetPodcastsRequest(type: .all).execute(onSuccess: { podcasts in
			controller.data = podcasts
		})
	}
	
	func loadSavedEpisodes(for controller: EpisodesViewController) {
		GetSavedEpisodesRequest().execute(onSuccess: { episodes in
			controller.topData = episodes
		})
	}
	
	func saveEpisode(by id: Int) {
		SaveEpisodeRequest(id: id).execute()
	}
}
