//
//  PodcastCollectionView.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class PodcastCollectionView: UIView, NibOwnerLoadable {
	@IBOutlet private var stackView: UIStackView!
	@IBOutlet private var stackViewHeightConstraint: NSLayoutConstraint!
	
	var data: [Int] = [1,2,3,4, 5, 6, 7, 8, 9, 10] {
		didSet { fillStackView() }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.loadNibContent()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.loadNibContent()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		layoutIfNeeded()
		fillStackView()
	}
}

//MARK: - View Helers
private extension PodcastCollectionView {
	func fillStackView() {
		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		
		data.forEach {
			_ = $0
			let view = PodcastView(title: "How to talk to investors on…",
								   image: URL(string: "https://upload.wikimedia.org/wikipedia/en/b/b6/StartUp_Podcast_Art.png"))
			stackView.addArrangedSubview(view)
			
			let proportionWidth: CGFloat = 0.75
			view.widthAnchor.constraint(equalToConstant: stackView.frame.height * proportionWidth).isActive = true
		}
	}
}
