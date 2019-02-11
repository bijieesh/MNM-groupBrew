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

    init(request: T) {
        self.request = request
        let controller = ShowsViewController()
		
        super.init(contentController: controller)
		
		controller.onClose = { [weak self] in
			self?.contentController.navigationController?.popViewController(animated: true)
		}

        loadContent(for: controller)
    }

    private func loadContent(for controller: ShowsViewController) {
        request.execute(
            
            onSuccess: {
                controller.data = $0
        },

            onError: {
                $0.display()
        })
    }
}
