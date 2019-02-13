//
//  ImageCollectionViewCell.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/7/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class ImageCollectionViewCell: UICollectionViewCell, NibReusable {
	@IBOutlet private var imageView: UIImageView!
	
	var image: URL? {
		didSet { imageView.sd_setImage(with: image) }
	}
	
	override var isSelected: Bool {
		didSet {
			backgroundColor = isSelected ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			imageView.alpha = isSelected ? 0.5 : 1
			imageView.layer.borderWidth = isSelected ? 2 : 0
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		imageView.sd_cancelCurrentImageLoad()
	}
}
