//
//  PodcastsListItemView.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

class PodcastsListItemView: UIView, NibOwnerLoadable {
    struct Data {
        let title: String
        let subtitle: String
        let imageUrl: URL? = nil
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    init(data: Data) {
        super.init(frame: .zero)
        loadNibContent()
        setup(with: data)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup(with data: Data) {
        if data.imageUrl != nil {
            imageView?.sd_setImage(with: data.imageUrl)
        }
        
        titleLabel?.text = data.title
        subtitleLabel?.text = data.subtitle
    }
}

extension Podcast {
    var listItemData: PodcastsListItemView.Data {
        return PodcastsListItemView.Data(title: title, subtitle: description)
    }
}
