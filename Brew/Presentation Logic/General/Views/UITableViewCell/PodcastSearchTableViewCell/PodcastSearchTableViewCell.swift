//
//  PodcastSearchTableViewCell.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/13/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class PodcastSearchTableViewCell: UITableViewCell, NibReusable {
	@IBOutlet private var logoImageView: UIImageView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var subtitleLabel: UILabel!
	
	var logoImage: URL? {
		didSet { logoImageView.sd_setImage(with: logoImage, placeholderImage: #imageLiteral(resourceName: "podcast_logo_big"), options: .retryFailed) }
	}
	
	var title: String? {
		didSet { titleLabel.text = title }
	}
	
	var subtitle: String? {
		didSet { subtitleLabel.text = subtitle }
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		logoImageView.sd_cancelCurrentImageLoad()
	}
}
