//
//  PodcastsListView.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class PodcastsListView: UIView, NibOwnerLoadable {

    var items: [PodcastsListItemView.Data] = [] {
        didSet {
            update()
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentStackView: UIStackView!

    init(items: [PodcastsListItemView.Data]) {
        self.items = items
        super.init(frame: .zero)
        loadNibContent()
        update()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }

    private func update() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for item in items {
            let view = PodcastsListItemView(data: item)
            contentStackView.addArrangedSubview(view)
        }
    }
}
