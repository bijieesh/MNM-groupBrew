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
			self?.showPriceController()

		}
		
		(contentController as? UINavigationController)?.setViewControllers([interestsViewController], animated: false)
	}
	
	func showPriceController() {
		let priceViewController = PriceViewController()
		
		priceViewController.onLaterTapped = { [weak self] in
			self?.onFinish?()
			self?.end()
		}
		
		priceViewController.onNextTapped = { [weak self] in
			self?.onFinish?()
			self?.end()
		}
		
		(contentController as? UINavigationController)?.pushViewController(priceViewController, animated: true)
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
		SaveLikedPodcastsRequest(idArray: idArray).execute(onSuccess: { success in
			
		}) { error in
			
		}
	}
}
