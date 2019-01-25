//
//  PodcastDetailViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class PodcastDetailViewController: AppViewController {
    
    @IBOutlet private var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var backButton: UIButton!
    
    @IBOutlet private var contentTableView: UITableView! {
        didSet {
            contentTableView.register(cellType: PodcastEpisodeCell.self)
        }
    }
}

extension PodcastDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PodcastDetailTableHeaderView.loadFromNib()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: PodcastEpisodeCell.self)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 154
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxHeight: CGFloat = 228
        let minHeight: CGFloat = backButton.frame.maxY

        let offset = scrollView.contentOffset.y

        let finalHeight = max(min(maxHeight - offset, maxHeight), minHeight)
        logoHeightConstraint.constant = finalHeight
        view.layoutIfNeeded()
    }
}

