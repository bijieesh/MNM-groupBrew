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

    @IBOutlet private var datelabel: UILabel!
    @IBOutlet private var episodeNameLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
}
