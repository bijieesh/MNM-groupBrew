//
//  ActivityListView.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class ActivityListView: UIView, NibOwnerLoadable {
	typealias ActivityAction = (Activity) -> Void
	
	@IBOutlet private var stackView: UIStackView!
	@IBOutlet private var stackViewHeightConstraint: NSLayoutConstraint!
	
	var onActivity: ActivityAction?
	var data: [Activity] = [] {
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
private extension ActivityListView {
	func fillStackView() {
		stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		
		data.forEach {
			let activity = $0
			let proportionWidth: CGFloat = 0.75
			let progress = CGFloat(activity.duration) / CGFloat(activity.episode.duration)
			let view = ActivityView(title: activity.episode.title, image: activity.episode.podcast?.albumArt?.url, progress: progress)
			
			view.onActivity = { [weak self] in
				self?.onActivity?(activity)
			}
			
			stackView.addArrangedSubview(view)
			view.widthAnchor.constraint(equalToConstant: stackView.frame.height * proportionWidth).isActive = true
		}
	}
}
