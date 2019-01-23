//
//  TagViewCell.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class TagViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private var tagNameLabel: UILabel!

    var title: String? {
        didSet {
            tagNameLabel.text = title
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        layer.cornerRadius = 4
        layer.borderWidth = 1
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 0 : 1
            self.backgroundColor = isSelected ? .appOrange : .white
            self.tagNameLabel.textColor = isSelected ? .white : .black
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)

        layoutAttributes.size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        return layoutAttributes
    }
}
