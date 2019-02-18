//
//  PodcastView.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import HGCircularSlider

final class PodcastView: UIView, NibOwnerLoadable {
	@IBOutlet private var progressView: CircularSlider!
	@IBOutlet private var backgroundView: UIView!
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var titleLable: UILabel!
	
	init(title: String, image: URL?) {
		super.init(frame: .zero)
		
		loadNibContent()
		self.titleLable.text = title
		self.imageView.sd_setImage(with: image)
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
