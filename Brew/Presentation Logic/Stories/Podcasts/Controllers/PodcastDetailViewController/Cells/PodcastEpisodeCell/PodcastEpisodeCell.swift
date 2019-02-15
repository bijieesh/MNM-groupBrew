//
//  PodcastEpisodeCell.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class PodcastEpisodeCell: UITableViewCell, NibReusable {

    var duration: String? {
        didSet {
            durationLabel.text = duration
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
	
	var descriptions: String? {
		didSet {
			descriptionLabel.text = descriptions
		}
	}

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var durationLabel: UILabel!
	
}
