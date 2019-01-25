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

    @IBInspectable var isHighlited: Bool = false

    @IBInspectable var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentStackView: UIStackView!

    init(items: [PodcastsListItemView.Data], isHighlited: Bool = false) {
        self.items = items
        self.isHighlited = isHighlited
        super.init(frame: .zero)
        loadNibContent()
        update()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }

    private func update() {
        guard !items.isEmpty else {
            isHidden = true
            return
        }

        isHidden = false

        let titleFontSize: CGFloat = isHighlited ? 24 : 17
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for item in items {
            let view: UIView = isHighlited ? PodcastsListHighlitedItemView(imageUrl: item.imageUrl) : PodcastsListItemView(data: item)
            contentStackView.addArrangedSubview(view)
        }
    }
}
