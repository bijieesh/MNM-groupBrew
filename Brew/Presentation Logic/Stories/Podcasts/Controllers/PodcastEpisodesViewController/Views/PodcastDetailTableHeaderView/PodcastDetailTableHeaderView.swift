//
//  PodcastDetailTableHeaderView.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

struct PodcastDetailData {
	var image: URL?
	var title: String?
	var description: String?
}

class PodcastDetailTableHeaderView: UIView, NibLoadable {
	
	//MARK: IBOutlets
	
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var exclusivesButton: UIButton!
	@IBOutlet weak var episodesButton: UIButton!
	@IBOutlet weak var exclusivesIndicateView: UIView!
	@IBOutlet weak var episodesIndicateView: UIView!
	
//    var onSubscribeTapped: (() -> Void)?
	
	var data: PodcastDetailData? {
		didSet { fillData() }
	}
	
	private func selectedButton(episodes: Bool, exclusives: Bool) {
		episodesButton.isSelected = episodes
		exclusivesButton.isSelected = exclusives
	}
	
	private func hideIndicateView(episodes: Bool, exclusives: Bool) {
		episodesIndicateView.isHidden = episodes
		exclusivesIndicateView.isHidden = exclusives
	}
	
	//MARK: Actions
	
	@IBAction func onEpisodesPressed(_ sender: Any) {
		selectedButton(episodes: true, exclusives: false)
		hideIndicateView(episodes: false, exclusives: true)
	}
	
	@IBAction func onExclusivesPressed(_ sender: Any) {
		selectedButton(episodes: false, exclusives: true)
		hideIndicateView(episodes: true, exclusives: false)
	}
	
	private func fillData() {
		logoImageView.sd_setImage(with: data?.image)
		titleLabel.text = data?.title
		descriptionLabel.text = data?.description
	}
}
