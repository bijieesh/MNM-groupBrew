//
//  CategoryCollectionViewCell.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class CategoryCollectionViewCell: UICollectionViewCell, NibReusable {
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var imageView: UIImageView!

	var image: URL? {
		didSet { imageView.sd_setImage(with: image) }
	}
	
	var title: String? {
		didSet { titleLabel.text = title }
	}
}
