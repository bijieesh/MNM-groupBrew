//
//  OnboardingCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/23/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {
	typealias Action = () -> Void?
	
	var onFinish: Action?

    override func start() {
        super.start()
		showInterests()
    }

    override func end() {
        onFinish?()
        super.end()
    }
}

//MARK: - Presentation Helpers
private extension OnboardingCoordinator {
	func showInterests() {
		let interestsViewController = InterestsViewController()
		
		loadPodcasts(for: interestsViewController)
		
		interestsViewController.onNext = { [weak self] podcasts in
			self?.sendSelected(podcasts)
			self?.end()
		}
		
		interestsViewController.onSkip = { [weak self] in
			self?.end()

		}
		
		(contentController as? UINavigationController)?.setViewControllers([interestsViewController], animated: false)
	}
}

//MARK: - Server Communication
private extension OnboardingCoordinator {
	func loadPodcasts(for controller: InterestsViewController) {
		GetPodcastsRequest(type: .all).execute(onSuccess: { podcasts in
			controller.podcasts = podcasts
		})
	}
	
	func sendSelected(_ podcasts: [Podcast]) {
		let idArray = podcasts.map { $0.id }
		SaveLikedPodcastsRequest(idArray: idArray).execute()
	}
}
