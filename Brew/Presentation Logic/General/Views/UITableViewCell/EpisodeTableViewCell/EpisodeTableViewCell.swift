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

final class EpisodeTableViewCell: MGSwipeTableCell, NibReusable {
	typealias Action = () -> Void
	
	struct Data {
		var image: URL?
		var title: String
		var subtitle: String
		var listeningProgress: Float = 0
	}

	//MARK: IBOutlets

    enum DownloadState {
        case downloaded
        case notDownloaded
        case downloading(progress: Float)
    }

    var downloadState: DownloadState = .notDownloaded {
        didSet {
            updateDownloadButton()
        }
    }
	
	@IBOutlet private var mainImageView: UIImageView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var subtitleLabel: UILabel!
	@IBOutlet private var progressView: UIProgressView!
	@IBOutlet private var saveButton: UIButton!
	@IBOutlet var bottomView: UIView!
	
	@IBAction func saveButtonPressed() {
        if case .notDownloaded = downloadState {
			onSavePressed?()
		}
        else if case .downloading = downloadState {
			onCancelDownloadPressed?()
		}
        else {
            onRemoveLocalFilePressed?()
        }
	}
	
	var onSavePressed: Action?
	var onCancelDownloadPressed: Action?
    var onRemoveLocalFilePressed: Action?
	
	func fill(data: Data) {
		mainImageView.sd_setImage(with: data.image)
		titleLabel.text = data.title
		subtitleLabel.text = data.subtitle
		progressView.progress = data.listeningProgress

        updateDownloadButton()
	}

    private func updateDownloadButton() {
        switch downloadState {
        case .downloaded:
            saveButton.setTitle("REMOVE", for: .normal)
        case .notDownloaded:
            saveButton.setTitle("DOWNLOAD", for: .normal)
        case .downloading(let progress):
            if progress >= 1 {
                downloadState = .downloaded
            }
            else {
                saveButton.setTitle("\(Int(progress*100))%", for: .normal)
            }
        }
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		mainImageView.sd_cancelCurrentImageLoad()
	}
}

extension EpisodeTableViewCell: AppFileLoaderProgressHandler {
	var progress: Float {
		get {
            if case .downloading(let progress) = downloadState {
                return progress
            }
            else {
                return 0
            }
        }
		set {
            downloadState = .downloading(progress: newValue)
        }
	}
}
