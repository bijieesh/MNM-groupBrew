//
//  HomeViewController.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class HomeViewController: AppViewController {
	@IBOutlet private var podcastsView: PodcastCollectionView! {
		didSet {
			
		}
	}
	@IBOutlet private var newPodcastsView: UIView!
}
