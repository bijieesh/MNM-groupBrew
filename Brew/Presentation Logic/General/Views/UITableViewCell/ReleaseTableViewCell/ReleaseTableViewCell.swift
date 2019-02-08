//
//  NewReleaseTableViewCell.swift
//  Music
//
//  Created by Vasyl Khmil on 1/31/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import MGSwipeTableCell
import NFDownloadButton

final class ReleaseTableViewCell: MGSwipeTableCell, NibReusable {
	struct Data {
		var image: URL?
		var title: String?
		var author: String?
	}

	//MARK: IBOutlets
	
	@IBOutlet private var mainImageView: UIImageView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var authorLabel: UILabel!
	@IBOutlet private var saveButton: NFDownloadButton!
	@IBOutlet private var progressView: UIProgressView!
	@IBOutlet var bottomView: UIView!
	
	@IBAction func saveButtonPressed() {

	}
	
	func fill(data: Data?) {
		mainImageView.sd_setImage(with: data?.image)
		titleLabel.text = data?.title
		authorLabel.text = data?.author
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		mainImageView.sd_cancelCurrentImageLoad()
	}
}
