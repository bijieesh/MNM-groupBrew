//
//  CommentCell.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

class CommentCell: UITableViewCell, NibReusable {

    var comment: String = "" {
        didSet {
            commentLabel.text = comment
        }
    }

    var avatarUrl: URL? {
        didSet {
            if let url = avatarUrl {
                imageView?.sd_setImage(with: url)
            }
        }
    }

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var commentLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = UIImage(named: "icon-profile")
    }
}
