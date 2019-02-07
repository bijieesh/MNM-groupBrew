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
		didSet { fillData() }
	}

    var onBackPressed: (() -> Void)?
    var onEpisodeSelected: ((Int) -> Void)?

    @IBOutlet private var backButton: UIButton!
	
	@IBOutlet private var contentTableView: UITableView! {
		didSet { configureTableView() }
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

    @IBAction private func backPressed() {
        onBackPressed?()
    }
	
	private lazy var headerView: PodcastDetailTableHeaderView = {
		let view = PodcastDetailTableHeaderView.loadFromNib()
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		headerView.frame = CGRect(x: 0, y: 0, width: contentTableView.frame.width, height: 600)
	}

}

private extension PodcastDetailViewController {
	func configureTableView() {
		contentTableView.register(cellType: PodcastEpisodeCell.self)
		contentTableView.tableHeaderView = headerView
	}
	
	func fillData() {
        guard let podcast = podcast else {
            return
        }

        let data = PodcastDetailTableHeaderView.Data.init(image: podcast.albumArt?.url,
                                                          title: podcast.title,
                                                          description: podcast.description,
                                                          authorName: podcast.user.profile.profileFullName)
		
		headerView.data = data
	}
}

//MARK: UITableViewDataSource

extension PodcastDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcast?.episodes?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: PodcastEpisodeCell = tableView.dequeueReusableCell(for: indexPath)
		
		guard let episode = podcast?.episodes?[indexPath.row] else {
			return cell
		}

		cell.title = episode.title
<<<<<<< Updated upstream
//        cell.duration = episode.duration
=======
//		cell.duration = episode.duration
>>>>>>> Stashed changes
		cell.descriptions = episode.description
		
		return cell
	}
}

//MARK: UITableViewDelegate

extension PodcastDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		onEpisodeSelected?(indexPath.row)
	}
}


//extension PodcastDetailViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = PodcastDetailTableHeaderView.loadFromNib()
//
//        view.podcastName = podcast?.title
//        view.podcastDescription = podcast?.description
//
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: PodcastEpisodeCell = tableView.dequeueReusableCell(for: indexPath)
//
//        guard let episode = podcast?.episodes?[indexPath.row] else {
//            return cell
//        }
//
//        cell.name = episode.title
//        cell.duration = episode.duration
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return podcast?.episodes?.count ?? 0
//		return 2
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        onEpisodeSelected?(indexPath.row)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let maxHeight: CGFloat = 228
//        let minHeight: CGFloat = backButton.frame.maxY
//
//        let offset = scrollView.contentOffset.y
//
//        let finalHeight = max(min(maxHeight - offset, maxHeight), minHeight)
//        logoHeightConstraint.constant = finalHeight
//        view.layoutIfNeeded()
//    }
//}
//
