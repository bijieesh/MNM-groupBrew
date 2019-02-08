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

	private var newSavedEpisodes: [Episode] = []
	private var oldSavedEpisodes: [Episode] = []

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
	
	func createNewReleaseController() -> NewReleaseViewController {
		let newReleaseVC = NewReleaseViewController()
		newReleaseVC.controllerType = .new
		
		newReleaseVC.onPodcastPressed = { [weak self] controllerType, podcastType, actionType, index in
			self?.handleNewReleaseControllerType(controllerType, dataType: podcastType, actionType: actionType, index: index)
		}
		
		loadNewReleasesData(for: newReleaseVC)
		
		return newReleaseVC
	}
	
	
	
	func createShowsController() -> ShowsViewController {
		let showsVC = ShowsViewController()
		loadShowsData(for: showsVC)
		
		showsVC.onPodcastPressed = { [weak self] in self?.showPodcastDetails(by: $0) }
		
		return showsVC
	}
	
	func createSavedController() -> NewReleaseViewController {
		let savedVC = NewReleaseViewController()
		savedVC.controllerType = .saved
		
		savedVC.onPodcastPressed = { [weak self] controllerType, podcastType, actionType, index in
			self?.handleNewReleaseControllerType(controllerType, dataType: podcastType, actionType: actionType, index: index)
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
	
	func showPodcastDetails(by index: Int) {
		let podcast = showsPodcasts[index]
		showPodcastDetails(for: podcast)
	}
}

//MARK: - Action Handlers
private extension HomeCoordinator {
	func handleNewReleaseControllerType(_ controllerType: NewReleaseViewController.ControllerType,
										dataType: NewReleaseViewController.DataType,
										actionType: NewReleaseViewController.ActionType,
										index: Int) {
		switch controllerType {
		case .new:
			switch dataType {
			case .new:
				let podcast = newPodcasts[index]
				handlePodcastAction(podcast: podcast, action: actionType)
			case .old:
				let podcast = oldPodcasts[index]
				handlePodcastAction(podcast: podcast, action: actionType)
			}
		case .saved:
			switch dataType {
			case .new:
				let episode = newSavedEpisodes[index]
				handleEpisodeAction(episode: episode, action: actionType)
			case .old:
				let episode = oldSavedEpisodes[index]
				handleEpisodeAction(episode: episode, action: actionType)
			}
		}
	}
	
	func handlePodcastAction(podcast: Podcast, action: NewReleaseViewController.ActionType) {
		switch action {
		case .leftAction:
			skip(podcast)
		case .rightAction:
			save(podcast)
		case .select:
			select(podcast)
		}
	}
	
	func handleEpisodeAction(episode: Episode, action: NewReleaseViewController.ActionType) {
		switch action {
		case .leftAction:
			break
		case .rightAction:
			delete(episode)
		case .select:
			select(episode)
		}
	}
	
	func skip(_ podcast: Podcast) {
		
	}
	
	func save(_ podcast: Podcast) {
		guard let id = podcast.episodes?.last?.id else { return }
		saveEpisode(by: id)
	}
	
	func select(_ podcast: Podcast) {
		
	}
	
	func delete(_ episode: Episode) {
		
	}
	
	func select(_ episode: Episode) {
		
	}
}

//MARK: - Server Communication
private extension HomeCoordinator {
	func loadNewReleasesData(for controller: NewReleaseViewController) {
		GetPodcastsRequest(type: .new).execute(onSuccess: { [weak self] podcasts in
			guard let self = self else { return }
			
			self.newPodcasts.removeAll()
			controller.newReleaseData = podcasts.compactMap {
				if let episode = $0.episodes?.last {
					self.newPodcasts.append($0)
					
					return ReleaseTableViewCell.Data(podcast: $0, episode: episode)
				}
				
				return nil
			}
		})
	}
	
	func loadShowsData(for controller: ShowsViewController) {
		GetPodcastsRequest(type: .all).execute(onSuccess: { [weak self] podcasts in
			self?.showsPodcasts = podcasts
			controller.data = podcasts
		})
	}
	
	func loadSavedEpisodes(for controller: NewReleaseViewController) {
		GetSavedEpisodeRequest().execute(onSuccess: { [weak self] episodes in
			guard let self = self else { return }
			
			self.newSavedEpisodes.removeAll()
			controller.newReleaseData = episodes.compactMap {
				if let podcast = $0.podcast {
					self.newSavedEpisodes.append($0)
					
					return ReleaseTableViewCell.Data(podcast: podcast, episode: $0)
				}
				
				return nil
			}
		})
	}
	
	func saveEpisode(by id: Int) {
		SaveEpisodeRequest(id: id).execute()
	}
}

private extension ReleaseTableViewCell.Data {
	init(podcast: Podcast, episode: Episode) {
		image = podcast.albumArt?.url
		title = podcast.title
		subtitle = podcast.user.profile.profileFullName
		fileIsDownloaded = (episode.file?.url.flatMap { AppFileLoader.shared.localFileUrl(for: $0) }) != nil
	}
}
