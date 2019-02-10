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
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		imageView.sd_cancelCurrentImageLoad()
	}
}
