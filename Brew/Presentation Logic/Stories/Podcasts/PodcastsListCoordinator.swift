//
//  PodcastsListCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/10/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class PodcastsListCoordinator<T>: Coordinator where T: RequestType, T.ResponseObjectType == [Podcast], T.ErrorType == SimpleError {

    private let request: T

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
		
		controller.onPodcastPressed = { podcast, episode in
//			self?.onNeedPlayPodcast?($0, $1)
		}
		
		contentController.navigationController?.pushViewController(controller, animated: true)
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
}
