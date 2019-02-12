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
    var onPodcastPressed: ((Podcast, Int) -> Void)?
	var onFirstCategoryPressed: ((Category) -> Void)?
	
    @IBOutlet private var backButton: UIButton!
	
	@IBOutlet private var contentTableView: UITableView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

    @IBAction private func backPressed() {
        onBackPressed?()
    }
	
	private lazy var headerView: PodcastDetailTableHeaderView = {
		let view = PodcastDetailTableHeaderView.loadFromNib()
		view.onFirstCategoryPressed = { [weak self] in
			self?.onFirstCategoryPressed?($0)
		}
		return view
	}()
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureTableView()
	}
}

private extension PodcastDetailViewController {
	func configureTableView() {
		contentTableView.register(cellType: PodcastEpisodeCell.self)
		contentTableView.rowHeight = UITableView.automaticDimension
	}
	
	func fillData() {
        guard let podcast = podcast else {
            return
        }

        let data = PodcastDetailTableHeaderView.Data.init(image: podcast.albumArt?.url,
                                                          title: podcast.title,
                                                          description: podcast.description,
                                                          authorName: podcast.user.profile?.profileFullName ?? "",
														  rating: podcast.totalRating,
														  podcastCategories: podcast.categories ?? [],
														  likesCount: podcast.likesCount
		)
		
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
		cell.descriptions = episode.description
		
		return cell
	}
}

//MARK: UITableViewDelegate

extension PodcastDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let podcast = podcast else { return }
		onPodcastPressed?(podcast, indexPath.row)
	}

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.expectedHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

