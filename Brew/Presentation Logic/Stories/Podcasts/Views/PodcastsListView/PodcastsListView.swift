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

    var onItemSelected: ((Int) -> Void)?

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

        for (index, item) in items.enumerated() {
            let view: UIView = isHighlited ? PodcastsListHighlitedItemView(imageUrl: item.imageUrl) : PodcastsListItemView(data: item)
            view.tag = index

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(podcastViewTapped(with:)))
            view.addGestureRecognizer(tapGesture)

            contentStackView.addArrangedSubview(view)
        }
    }

    @objc private func podcastViewTapped(with recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view else {
            return
        }

        selectedPodcast(at: view.tag)
    }

    private func selectedPodcast(at index: Int) {
        onItemSelected?(index)
    }
}
