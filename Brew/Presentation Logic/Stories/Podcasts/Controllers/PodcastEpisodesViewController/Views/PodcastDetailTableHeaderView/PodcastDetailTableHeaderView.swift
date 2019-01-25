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
    
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var autorNameLabel: UILabel!
    @IBOutlet private var subscribeButton: UIButton!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBAction private func subscribeTapped() {
        onSubscribeTapped?()
    }
}
