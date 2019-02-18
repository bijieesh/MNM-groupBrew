//
//  HomeViewController.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class HomeViewController: AppViewController {
	typealias Action = () -> Void
	typealias ActivityIndex = (Activity) -> Void
	
	@IBOutlet private var podcastsView: ActivityListView! {
		didSet { configureActivityView() }
	}
	@IBOutlet private var newPodcastsView: UIView!
	
	var onGetData: Action?
	var onActivity: ActivityIndex?
	
	var activities: [Activity] = [] {
		didSet { podcastsView.data = activities }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		onGetData?()
	}
}

//MARK: - Controller Helpers
private extension HomeViewController {
	func configureActivityView() {
		podcastsView.onActivity = { [weak self] activity in
			self?.onActivity?(activity)
		}
	}
}
