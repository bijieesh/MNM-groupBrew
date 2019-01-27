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

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
}
