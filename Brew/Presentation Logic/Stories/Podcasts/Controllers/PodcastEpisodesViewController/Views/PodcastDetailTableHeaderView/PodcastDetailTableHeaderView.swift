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
    struct Data {
        let image: URL?
        let title: String
        let description: String
        let authorName: String
		let rating: Int
		let podcastCategories: [Category]
		let likesCount: Int
    }
	
	var onFirstCategoryPressed: ((Category) -> Void)?
	
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
	
//    var onSubscribeTapped: (() -> Void)?
	
	var data: Data? {
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
	
	@IBAction func firstCategoryButtonPressed() {
		if let category = data?.podcastCategories.first {
			onFirstCategoryPressed?(category)
		}
	}
	
	private func fillData() {
		logoImageView.sd_setImage(with: data?.image)
		titleLabel.text = data?.title
		descriptionLabel.text = data?.description

        if let authorName = data?.authorName {
            authorNameLabel.text = "By \(authorName)"
        }
		
		if let rating = data?.rating {
			ratingView.rating = rating
			ratingLabel.text = "(\(rating))"
		}
		
		if let likes = data?.likesCount {
			likesCountLabel.text = "\(likes)"
		}
		
		if let categories = data?.podcastCategories {
			if categories.count >= 1 {
				if let title = data?.podcastCategories.first?.name {
					firstCategoryButton.setTitle("   \(title)   ", for: .normal)
					firstCategoryButton.isHidden = false
				}
			}
		}
	}
}
