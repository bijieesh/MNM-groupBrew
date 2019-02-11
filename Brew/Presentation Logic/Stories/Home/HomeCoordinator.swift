//
//  HomeCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeCoordinator: NavigationCoordinator {
	typealias EpisodeAction = (Episode) -> Void
	typealias PodcastAction = (Podcast, Int) -> Void
	
	var onEpisodePressed: EpisodeAction?
	var onPodcastPressed: PodcastAction?

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
		
		newReleaseVC.onPodcastPressed = { [weak self] episode, actionType in
			self?.handleActionOn(episode, action: actionType)
		}
		
		loadNewReleasesData(for: newReleaseVC)
		
		return newReleaseVC
	}
	
	func createShowsController() -> ShowsViewController {
		let showsVC = ShowsViewController()
		loadShowsData(for: showsVC)
		showsVC.back = true
		
		showsVC.onPodcastPressed = { [weak self] podcast in
			self?.showDetails(for: podcast)
		}
		
		return showsVC
	}
	
	func createSavedController() -> EpisodesViewController {
		let savedVC = EpisodesViewController()
		savedVC.controllerType = .saved
		
		savedVC.onPodcastPressed = { [weak self] episode, actionType in
			self?.handleActionOn(episode, action: actionType)
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
	
	func showDetails(for podcast: Podcast) {
		let controller = PodcastDetailViewController()
		controller.podcast = podcast
		
		controller.onBackPressed = { [weak self] in self?.navigationController?.popViewController(animated: true) }
		controller.onPodcastPressed = { [weak self] in self?.onPodcastPressed?($0, $1) }
		
		navigationController?.pushViewController(controller, animated: true)
	}
}

//MARK: - Action Handlers
private extension HomeCoordinator {
	func handleActionOn(_ episode: Episode, action: EpisodesViewController.ActionType) {
		switch action {
		case .select:
			select(episode)
		case .save:
			save(episode)
		case .delete:
			delete(episode)
		}
	}
	
	func save(_ episode: Episode) {
		saveEpisode(by: episode.id)
	}
	
	func delete(_ episode: Episode) {
		
	}
	
	func select(_ episode: Episode) {
		onEpisodePressed?(episode)
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
