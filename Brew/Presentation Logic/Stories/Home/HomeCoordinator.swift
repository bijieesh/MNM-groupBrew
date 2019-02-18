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
	typealias ActivityAction = (Episode, Int) -> Void
	
	var onEpisode: EpisodeAction?
	var onPodcast: PodcastAction?
	var onActivity: ActivityAction?

    override func start() {
        super.start()
		
		createHomeContainer()
		navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		navigationController?.navigationBar.isTranslucent = false
    }
}

//MARK: - Controller Presentation
private extension HomeCoordinator {
	func createHomeController() -> HomeViewController {
		let homeVC = HomeViewController()
		
		return homeVC
	}
	
	func createShowsController() -> ShowsViewController {
		let showsVC = ShowsViewController()
		
		showsVC.onPodcastPressed = { [weak self] podcast in
			self?.showDetails(for: podcast)
		}
		
		showsVC.onNeedUpdate = { [weak self, weak showsVC] in
			self?.loadShowsData(for: showsVC)
		}
		
		return showsVC
	}
	
	func createSavedController() -> EpisodesViewController {
		let savedVC = EpisodesViewController()
		savedVC.controllerType = .saved
		
		savedVC.onPodcast = { [weak self] episode, actionType in
			self?.handleActionOn(episode, action: actionType)
		}
		
		savedVC.onActivity = { [weak self] in
			self?.onActivity?($0, $1)
		}
		
		savedVC.onNeedUpdate = { [weak self, weak savedVC] in
			self?.loadSavedEpisodes(for: savedVC)
			self?.loadUserEpisodes(for: savedVC)
		}
		
		return savedVC
	}
	
	func createHomeContainer() {
		let home = createHomeController()
		let shows = createShowsController()
		let saved = createSavedController()
		
		let homeContainer = HomeContainerViewController()
		
		homeContainer.controllers = [home, shows, saved]
		
		navigationController?.pushViewController(homeContainer, animated: true)
	}
	
	func showDetails(for podcast: Podcast) {
		let controller = PodcastDetailViewController()
		controller.podcast = podcast
		
		controller.onBack = { [weak self] in
			self?.navigationController?.setNavigationBarHidden(true, animated: true)
			self?.navigationController?.popViewController(animated: true)
		}
		
		controller.onPodcast = { [weak self] in self?.onPodcast?($0, $1) }
		controller.onFirstCategory = { [weak self] in
			self?.show($0)
		}
		
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
		case .skip:
			skip(episode)
		case .delete:
			delete(episode)
		}
	}
	
	func save(_ episode: Episode) {
		saveEpisode(by: episode.id)
	}
	
	func delete(_ episode: Episode) {
		deleteEpisode(by: episode.id)
	}
	
	func select(_ episode: Episode) {
		onEpisode?(episode)
	}
	
	func skip(_ episode: Episode) {
		skipEpisode(by: episode.id)
	}
}

//MARK: - Server Communication
private extension HomeCoordinator {
	func loadNewEpisodes(for controller: EpisodesViewController?) {
        GetNewReleasesRequest().execute(onSuccess: { episodes in
			controller?.topData = episodes
        })
	}
	
	func loadShowsData(for controller: ShowsViewController?) {
		GetPodcastsRequest(type: .all).execute(onSuccess: { podcasts in
			controller?.data = podcasts
		})
	}
	
	func loadSavedEpisodes(for controller: EpisodesViewController?) {
		GetSavedEpisodesRequest().execute(onSuccess: { episodes in
			controller?.topData = episodes
		})
	}
	
	func saveEpisode(by id: Int) {
		SaveEpisodeRequest(id: id).execute()
	}
	
	func skipEpisode(by id: Int) {
		SkipEpisodeRequest(id: id).execute()
	}
	
	func deleteEpisode(by id: Int) {
		DeleteUserEpisodeRequest(id: id).execute()
	}
	
	private func show(_ category: Category) {
		let request = GetPodcastsRequest(categoryId: category.id)
		let coordinator = PodcastsListCoordinator(request: request)
		
		coordinator.start()
		navigationController?.pushViewController(coordinator.contentController, animated: true)
	}
	
	func loadUserEpisodes(for controller: EpisodesViewController?) {
		GetUserActivitiesRequest().execute(onSuccess: { activities in
			controller?.bottomData = activities
		})
	}
}
