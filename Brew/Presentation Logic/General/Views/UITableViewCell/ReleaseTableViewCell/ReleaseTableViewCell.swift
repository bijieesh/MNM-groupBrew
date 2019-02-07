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

final class ReleaseTableViewCell: MGSwipeTableCell, NibReusable {

	//MARK: IBOutlets
	
	@IBOutlet private var progressView: UIProgressView!
	@IBOutlet var bottomView: UIView!
}
