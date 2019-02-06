//
//  PlayButton.swift
//  Music
//
//  Created by  on 1/31/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class PodcastButton: BaseButton {
	
	@IBOutlet weak var buttonImageView: UIImageView!
	
	@IBInspectable
	var image: UIImage {
		get { return buttonImageView.image  ?? UIImage() }
		set { buttonImageView.image = newValue }
	}
}
