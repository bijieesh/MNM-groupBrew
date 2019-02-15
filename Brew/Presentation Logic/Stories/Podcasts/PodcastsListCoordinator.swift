//
//  PodcastsListCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/10/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class PodcastsListCoordinator<T>: Coordinator where T: RequestType, T.ResponseObjectType == [Podcast], T.ErrorType == SimpleError {
	typealias PodcastAction = (Podcast, Int) -> Void

    private let request: T
	
	var onPodcast: PodcastAction?

	init(request: T, title: String? = nil) {
        self.request = request
        let controller = ShowsViewController()
		controller.title = title
		
        super.init(contentController: controller)
		
		controller.onClose = { [weak self] in
			self?.contentController.navigationController?.popViewController(animated: true)
		}
		
		controller.onPodcastPressed = { [weak self] podcast in
			self?.showDetails(for: podcast)
		}

        loadContent(for: controller)
    }
}

//MARK: - Coordinator Helpers
private extension PodcastsListCoordinator {
	func showDetails(for podcast: Podcast) {
		let controller = PodcastDetailViewController()
		controller.podcast = podcast
		
		controller.onBack = { [weak self] in
			self?.contentController.navigationController?.popViewController(animated: true)
		}
		
		controller.onPodcast = { [weak self] in
			self?.onPodcast?($0, $1)
		}
		
		controller.onFirstCategory = { [weak self] category in
			self?.show(category)
		}
		
		controller.onSave = { [weak self] in
			self?.save($0)
		}
		
		contentController.navigationController?.pushViewController(controller, animated: true)
	}
	
	func show(_ category: Category) {
		let request = GetPodcastsRequest(categoryId: category.id)
		loadPodcatListCoordinator(with: request, title: category.name)
	}
	
	func loadPodcatListCoordinator<T: RequestType>(with request: T, title: String) where T.ResponseObjectType == [Podcast], T.ErrorType == SimpleError {
		let coordinator = PodcastsListCoordinator<T>(request: request, title: title)
		coordinator.start()
		
		coordinator.onPodcast = { [weak self] in
			self?.onPodcast?($0, $1)
		}
		
		contentController.navigationController?.pushViewController(coordinator.contentController, animated: true)
	}
	
	func save(_ episode: Episode) {
		saveEpisode(by: episode.id)
	}
}
	
//MARK: - Server Communication
private extension PodcastsListCoordinator {
	func loadContent(for controller: ShowsViewController) {
		request.execute( onSuccess: {
			controller.data = $0
		}, onError: {
			$0.display()
		})
	}
	
	func saveEpisode(by id: Int) {
		SaveEpisodeRequest(id: id).execute()
	}
}
