//
//  PodcastDetailViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

class PodcastDetailViewController: AppViewController {

    var podcast: Podcast? {
        didSet {
            updateUI()
        }
    }

    var onBackPressed: (() -> Void)?
    var onEpisodeSelected: ((Int) -> Void)?

    @IBOutlet private var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var backButton: UIButton!
    
    @IBOutlet private var contentTableView: UITableView! {
        didSet {
            contentTableView.register(cellType: PodcastEpisodeCell.self)
        }
    }

    @IBAction private func backPressed() {
        onBackPressed?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    private func updateUI() {
        guard isViewLoaded else {
            return
        }

        if let url = podcast?.albumArt?.url {
            logoImageView.sd_setImage(with: url)
        }

        contentTableView.reloadData()
    }
}

extension PodcastDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PodcastDetailTableHeaderView.loadFromNib()

        view.podcastName = podcast?.title
        view.podcastDescription = podcast?.description

        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PodcastEpisodeCell = tableView.dequeueReusableCell(for: indexPath)

        guard let episode = podcast?.episodes?[indexPath.row] else {
            return cell
        }

        cell.name = episode.title

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcast?.episodes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onEpisodeSelected?(indexPath.row)
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

