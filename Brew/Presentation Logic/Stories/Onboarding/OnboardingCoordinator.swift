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
}

//MARK: - Presentation Helpers
private extension OnboardingCoordinator {
	func showInterests() {
		let interestsViewController = InterestsViewController()
		
		loadPodcasts(for: interestsViewController)
		
		interestsViewController.onNext = { [weak self] podcasts in
			self?.sendSelected(podcasts)
			self?.showPriceController()
		}
		
		interestsViewController.onSkip = { [weak self] in
			self?.onFinish?()
		}
		
		contentController.present(interestsViewController, animated: false)
	}
	
	func showPriceController() {
		let priceViewController = PriceViewController()
		
		priceViewController.onLaterTapped = { [weak self] in
			self?.end()
			self?.onFinish?()
		}
		
		priceViewController.onNextTapped = { [weak self] in
			self?.end()
			self?.onFinish?()
		}
		
		contentController.topController.present(priceViewController, animated: false)
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
		
	}
}
