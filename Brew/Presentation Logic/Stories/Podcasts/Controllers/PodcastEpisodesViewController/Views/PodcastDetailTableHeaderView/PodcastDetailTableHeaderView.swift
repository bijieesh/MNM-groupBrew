//
//  PodcastDetailTableHeaderView.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class PodcastDetailTableHeaderView: UIView, NibLoadable {
    
    var onSubscribeTapped: (() -> Void)?

    var podcastName: String? {
        didSet {
            podcastNameLabel.text = podcastName
        }
    }

    var podcastDescription: String? {
        didSet {
            descriptionLabel.text = podcastDescription
        }
    }
    
    @IBOutlet private var podcastNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBAction private func subscribeTapped() {
        onSubscribeTapped?()
    }
}
