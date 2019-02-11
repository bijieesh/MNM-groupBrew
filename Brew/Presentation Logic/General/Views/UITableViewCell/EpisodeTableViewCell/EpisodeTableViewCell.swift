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

final class EpisodeTableViewCell: MGSwipeTableCell, NibReusable {
	typealias Action = () -> Void
	
	struct Data {
		var image: URL?
		var title: String
		var subtitle: String
		var fileIsDownloaded: Bool = false
	}

	//MARK: IBOutlets
	
	@IBOutlet private var mainImageView: UIImageView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var subtitleLabel: UILabel!
	@IBOutlet private var saveButton: NFDownloadButton!
	@IBOutlet private var progressView: UIProgressView!
	@IBOutlet var bottomView: UIView!
	
	@IBAction func saveButtonPressed() {
		onSavePressed?()
	}
	
	var onSavePressed: Action?
	
	func fill(data: Data) {
		mainImageView.sd_setImage(with: data.image)
		titleLabel.text = data.title
		subtitleLabel.text = data.subtitle
		saveButton.isDownloaded = data.fileIsDownloaded
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		mainImageView.sd_cancelCurrentImageLoad()
	}
}

extension EpisodeTableViewCell: AppFileLoaderProgressHandler {
	var progress: Float {
		get { return Float(saveButton.downloadPercent) }
		set { saveButton.downloadPercent = CGFloat(progress) }
	}
}
