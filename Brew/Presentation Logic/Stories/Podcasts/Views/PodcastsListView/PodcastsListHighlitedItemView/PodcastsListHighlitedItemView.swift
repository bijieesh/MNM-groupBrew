//
//  PodcastsListIHighlitedtemView.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

import UIKit
import Reusable
import SDWebImage

class PodcastsListHighlitedItemView: UIView, NibOwnerLoadable {

    @IBOutlet private var imageView: UIImageView!

    init(imageUrl: URL) {
        super.init(frame: .zero)
        loadNibContent()
        imageView?.sd_setImage(with: imageUrl)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
