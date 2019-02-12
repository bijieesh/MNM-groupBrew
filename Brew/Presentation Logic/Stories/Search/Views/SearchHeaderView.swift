//
//  SearchHeaderView.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class SearchHeaderView: UICollectionReusableView, NibReusable {
	typealias Action = () -> Void
	
	var onTopPodcast: Action?
	var onEditorsChoice: Action?
}

//MARK: - @IBAtion
private extension SearchHeaderView {
	@IBAction func topPodcastPressed() {
		onTopPodcast?()
	}
	
	@IBAction func editorsChoicePressed() {
		onEditorsChoice?()
	}
}
