//
//  ActivityView.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import HGCircularSlider

final class ActivityView: UIView, NibOwnerLoadable {
	typealias Action = () -> Void
	
	@IBOutlet private var progressView: CircularSlider!
	@IBOutlet private var backgroundView: UIView!
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var titleLable: UILabel!
	
	var onActivity: Action?
	
	init(title: String, image: URL?, progress: CGFloat) {
		super.init(frame: .zero)
		
		loadNibContent()
		self.titleLable.text = title
		self.imageView.sd_setImage(with: image)
		self.progressView.endPointValue = progress
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		loadNibContent()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		layoutIfNeeded()
		backgroundView.layer.cornerRadius = backgroundView.frame.width / 2
		imageView.layer.cornerRadius = imageView.frame.width / 2
	}
}

private extension ActivityView {
	@IBAction func onActivityPressed() {
		onActivity?()
	}
}
