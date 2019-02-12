//
//  PodcastDetailTableHeaderView.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import STRatingControl

class PodcastDetailTableHeaderView: UIView, NibLoadable {

    var podcast: Podcast? {
        didSet {
            updateUI()
        }
    }
	
	var onFirstCategoryPressed: ((Category) -> Void)?
    var onSubscribe: (() -> Void)?
    var onUnsubscribe: (() -> Void)?
	
	let expectedHeight: CGFloat = 623
	
	//MARK: IBOutlets
	
	@IBOutlet private var ratingView: STRatingControl!
	@IBOutlet private var ratingLabel: UILabel!
	@IBOutlet private var likesCountLabel: UILabel!
	@IBOutlet private var logoImageView: UIImageView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var authorNameLabel: UILabel!
	@IBOutlet private var exclusivesButton: UIButton!
	@IBOutlet private var episodesButton: UIButton!
	@IBOutlet private var exclusivesIndicateView: UIView!
	@IBOutlet private var episodesIndicateView: UIView!
	@IBOutlet private var firstCategoryButton: UIButton!
    @IBOutlet private var subscribeButton: UIButton!
	
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
	
	@IBAction func firstCategoryButtonPressed() {
		if let category = podcast?.categories?.first {
			onFirstCategoryPressed?(category)
		}
	}

    @IBAction func onSubscribePressed() {
        if podcast?.isFollowing == false {
            onSubscribe?()
        }
        else {
            onUnsubscribe?()
        }
    }
	
	private func updateUI() {
        guard let podcast = podcast else {
            return
        }

		logoImageView.sd_setImage(with: podcast.albumArt?.url)
		titleLabel.text = podcast.title
		descriptionLabel.text = podcast.description

        if podcast.isFollowing {
            subscribeButton.setTitle("Unsubscribe", for: .normal)
        }
        else {
            subscribeButton.setTitle("Subscribe", for: .normal)
        }

        if let authorName = podcast.user.profile?.profileFullName {
            authorNameLabel.text = "By \(authorName)"
        }

        ratingView.rating = podcast.totalRating
        ratingLabel.text = "(\(podcast.totalRating))"
		likesCountLabel.text = "\(podcast.likesCount)"

        if let title = podcast.categories?.first?.name {
            firstCategoryButton.setTitle("   \(title)   ", for: .normal)
            firstCategoryButton.isHidden = false
        }
	}
}
