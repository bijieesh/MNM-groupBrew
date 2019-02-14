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
	typealias Action = () -> Void
	typealias PodcastAction = (Podcast, Int) -> Void
	typealias CategoryAction = (Category) -> Void
	
	var podcast: Podcast? {
		didSet { fillData() }
	}

    var onBack: Action?
    var onPodcast: PodcastAction?
	var onFirstCategory: CategoryAction?
	
	@IBOutlet private var contentTableView: UITableView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    private lazy var headerView: PodcastDetailTableHeaderView = {

		let view = PodcastDetailTableHeaderView.loadFromNib()

		view.onFirstCategoryPressed = { [weak self] in
			self?.onFirstCategory?($0)
		}
        
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureNavigationBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureTableView()
	}
}

private extension PodcastDetailViewController {
	func configureNavigationBar() {
		let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back.pdf"), style: .plain, target: self, action: #selector(backButtonPressed))
		backButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		navigationItem.leftBarButtonItem = backButton
		navigationItem.largeTitleDisplayMode = .never
	}
	
	@objc func backButtonPressed() {
		onBack?()
	}
	
	func configureTableView() {
		contentTableView.register(cellType: EpisodeTableViewCell.self)
	}
	
	func fillData() {
		headerView.podcast = podcast

        if var podcast = podcast {
            headerView.onSubscribe = { [weak self] in
                SubscribeToPodcastRequest(podcastId: podcast.id).execute()
                podcast.handleSubscribe()
                self?.headerView.podcast = podcast
            }

            headerView.onUnsubscribe = { [weak self] in
                UnsubscribeFromPodcastRequest(podcastId: podcast.id).execute()
                podcast.handleUnsubscribe()
                self?.headerView.podcast = podcast
            }
        }
	}
}

//MARK: - Save File Helpers
private extension PodcastDetailViewController {
	func save(_ episode: Episode, for cell: EpisodeTableViewCell) {
		guard let url = episode.file?.url else { return }
		
		AppFileLoader.shared.storeFile(from: url, progressHandler: cell)
	}
	
	func cancelDownload(for episode: Episode, cell: EpisodeTableViewCell) {
		guard let url = episode.file?.url else { return }
		
		AppFileLoader.shared.cancelLoading(from: url)
		cell.downloadState = .notDownloaded
	}
	
	func removeDownload(for episode: Episode, cell: EpisodeTableViewCell) {
		guard let url = episode.file?.url else { return }
		
		cell.downloadState = .notDownloaded
		AppFileLoader.shared.deleteFile(for: url)
	}
}

//MARK: - UITableViewDataSource
extension PodcastDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcast?.episodes?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: EpisodeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		
		guard let episode = podcast?.episodes?[indexPath.row] else {
			return cell
		}
		
		let cellData = EpisodeTableViewCell.Data(image: episode.podcast?.albumArt?.url,
												 title: episode.title,
												 subtitle: episode.description,
												 listeningProgress: 0)

		cell.fill(data: cellData)
		cell.bottomView.isHidden = true
		
		cell.onSave = { [weak self] in
			self?.save(episode, for: cell)
		}
		
		cell.onCancelDownload = { [weak self] in
			self?.cancelDownload(for: episode, cell: cell)
		}
		
		cell.onRemoveLocalFile = { [weak self] in
			self?.removeDownload(for: episode, cell: cell)
		}
		
		if let url = episode.file?.url {
			if AppFileLoader.shared.localFileUrl(for: url) != nil {
				cell.downloadState = .downloaded
			}
			else if AppFileLoader.shared.isLoading(url) {
				cell.downloadState = .downloading(progress: 0)
			}
			else {
				cell.downloadState = .notDownloaded
			}
		}

		
		return cell
	}
}

//MARK: UITableViewDelegate

extension PodcastDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let podcast = podcast else { return }
		onPodcast?(podcast, indexPath.row)
	}

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.expectedHeight
    }
}

