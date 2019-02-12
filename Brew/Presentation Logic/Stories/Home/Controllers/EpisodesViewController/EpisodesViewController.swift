//
//  NewReleaseVC.swift
//  Music
//
//  Created by Vasyl Khmil on 1/31/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Reusable

class EpisodesViewController: UIViewController {
	typealias PodcastAction = (_ episode: Episode, _ actionType: ActionType) -> Void
	
	enum ControllerType {
		case new, saved
	}
	
	enum ActionType {
		case save, delete, skip, select
	}
	
	//MARK: IBOutlets
	@IBOutlet private var topTableView: UITableView! {
		didSet { configureTopTableView() }
	}
	
	@IBOutlet private var bottomTableView: UITableView! {
		didSet { configureBottomTableView() }
	}
	
	@IBOutlet private var showMoreView: UIView!
	@IBOutlet private var bottomTableViewHeaderView: UIView!
	
	@IBOutlet private var topTableViewHeight: NSLayoutConstraint!
	@IBOutlet private var bottomTableViewHeight: NSLayoutConstraint!
	@IBOutlet private var seeMoreViewHeight: NSLayoutConstraint!
	
	//MARK: Properties
	private var topCellHeight: CGFloat = 140
	private var bottomCellHeight: CGFloat = 165
	
	var topData: [Episode] = [] {
		didSet { topControllerData = topData.map { EpisodeTableViewCell.Data(episode: $0) } }
	}
	
	var bottomData: [Activity] = [] {
		didSet { bottomControllerData = bottomData.map { EpisodeTableViewCell.Data(activity: $0) } }
	}
	
	private var topControllerData: [EpisodeTableViewCell.Data] = [] {
		didSet { handleTopData() }
	}
	
	private var bottomControllerData: [EpisodeTableViewCell.Data] = [] {
		didSet { handleBottomData() }
	}
	
	var controllerType: ControllerType!
	var onPodcastPressed: PodcastAction?
}

//MARK: - @IBAction
private extension EpisodesViewController {
	@IBAction func onSeeMorePressed() {
		topTableViewHeight.constant = topCellHeight * CGFloat(topData.count)
		showMoreView.isHidden = true
	}
}

//MARK: - Controller Helpers
private extension EpisodesViewController {
	func save(_ episode: Episode, for cell: EpisodeTableViewCell) {
		guard let url = episode.file?.url else { return }

		AppFileLoader.shared.storeFile(from: url, progressHandler: cell)
	}
	
	func cancelDownload(for episode: Episode, cell: EpisodeTableViewCell) {
		guard let url = episode.file?.url else { return }
		
		cell.downloadState = .notDownloaded
		AppFileLoader.shared.cancelLoading(from: url)
	}

    func removeDownload(for episode: Episode, cell: EpisodeTableViewCell) {
        guard let url = episode.file?.url else { return }

        cell.downloadState = .notDownloaded
        AppFileLoader.shared.deleteFile(for: url)
    }
}

//MARK: - TableView Helpers
private extension EpisodesViewController {
	func handleTopData() {
		topTableViewHeight.constant = topCellHeight * CGFloat((topData.count < 4 ? topData.count : 3))
		showMoreView.isHidden = topData.count < 4
		topTableView.reloadData()
	}
	
	func handleBottomData() {
		bottomTableViewHeight.constant = bottomCellHeight * CGFloat(bottomData.count)
		bottomTableViewHeaderView.isHidden = false
		bottomTableView.isHidden = false
		bottomTableView.reloadData()
	}
	
	func configureTopTableView() {
		topTableView.register(cellType: EpisodeTableViewCell.self)
	}
	
	func configureBottomTableView() {
		bottomTableView.register(cellType: EpisodeTableViewCell.self)
	}
	
	func fillCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell: EpisodeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		
		if tableView == topTableView {
			cell.bottomView.isHidden = true

			return fill(cell, with: topControllerData, originalData: topData, at: indexPath.row)
		}
		
		if tableView == bottomTableView {
			cell.bottomView.isHidden = false
			
			return fill(cell, with: bottomControllerData, originalData: bottomData.map { $0.episode }, at: indexPath.row)
		}
		
		return cell
	}
	
	func fill(_ cell: EpisodeTableViewCell, with data: [EpisodeTableViewCell.Data], originalData: [Episode], at index: Int) -> UITableViewCell {
		let cellData = data[index]
		
		cell.fill(data: cellData)

        let episode = originalData[index]

		cell.onSavePressed = { [weak self] in
			self?.save(episode, for: cell)
		}
		
		cell.onCancelDownloadPressed = { [weak self] in
			self?.cancelDownload(for: episode, cell: cell)
		}

        cell.onRemoveLocalFilePressed = { [weak self] in
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
		
		configureSwipe(for: cell)
		
		return cell
	}
	
	func configureSwipe(for cell: EpisodeTableViewCell) {
		cell.delegate = self
		
		let leftButton = MGSwipeButton(title: "Skip      ", backgroundColor: #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.102151113))
		leftButton.setTitleColor(#colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 1), for: .normal)
		cell.leftButtons = [leftButton]
		cell.leftSwipeSettings.transition = .clipCenter
		cell.leftExpansion.expansionColor = #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.1012949486)
		cell.leftExpansion.buttonIndex = 0
		cell.leftExpansion.fillOnTrigger = true
		cell.leftExpansion.threshold = 2
		
		if controllerType == .new {
			let rightButton = MGSwipeButton(title: "Save      ", backgroundColor: #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.102151113))
			rightButton.setTitleColor(#colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 1), for: .normal)
			cell.rightButtons = [rightButton]
			cell.rightSwipeSettings.transition = .clipCenter
			cell.rightExpansion.expansionColor = #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.1012949486)
			cell.rightExpansion.buttonIndex = 0
			cell.rightExpansion.fillOnTrigger = true
			cell.rightExpansion.threshold = 2
		} else {
			let rightButton = MGSwipeButton(title: "Delete      ", backgroundColor: #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.102151113))
			rightButton.setTitleColor(#colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1), for: .normal)
			cell.rightButtons = [rightButton]
			cell.rightSwipeSettings.transition = .clipCenter
			cell.rightExpansion.expansionColor = #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.1012949486)
			cell.rightExpansion.buttonIndex = 0
			cell.rightExpansion.fillOnTrigger = true
			cell.rightExpansion.threshold = 2
		}
	}
}

//MARK: UITableViewDataSource
extension EpisodesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableView == topTableView ? topData.count : bottomData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.fillCell(for:tableView, indexPath: indexPath)
	}
}

//MARK: - UITableViewDelegate
extension EpisodesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let podcast = tableView == topTableView
			? topData[indexPath.row]
			: bottomData[indexPath.row].episode
		
		onPodcastPressed?(podcast, .select)
	}
}

//MARK: - MGSwipeTableCellDelegate
extension EpisodesViewController: MGSwipeTableCellDelegate {
	func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
		let topIndexPath = topTableView.indexPath(for: cell)
		let bottomIndexPath = bottomTableView.indexPath(for: cell)
		
		
		if let topIndexPath = topIndexPath {
			let podcast = topData[topIndexPath.row]

			if direction == .leftToRight {
				onPodcastPressed?(podcast, .skip)
				
				topTableView.performBatchUpdates({
					topData.remove(at: topIndexPath.row)
					topTableView.deleteRows(at: [topIndexPath], with: .top)
				})
			}
			
			if controllerType == .saved {
				onPodcastPressed?(podcast, .delete)
				
				topTableView.performBatchUpdates({
					topData.remove(at: topIndexPath.row)
					topTableView.deleteRows(at: [topIndexPath], with: .top)
				})
			} else {
				onPodcastPressed?(podcast, .save)
			}
		}
		
		if let bottomIndexPath = bottomIndexPath {
			let podcast = bottomData[bottomIndexPath.row].episode
			
			if direction == .leftToRight {
				onPodcastPressed?(podcast, .skip)
				
				topTableView.performBatchUpdates({
					topData.remove(at: bottomIndexPath.row)
					topTableView.deleteRows(at: [bottomIndexPath], with: .top)
				})
			}
			
			if controllerType == .saved {
				onPodcastPressed?(podcast, .delete)
				
				bottomTableView.performBatchUpdates({
					bottomData.remove(at: bottomIndexPath.row)
					bottomTableView.deleteRows(at: [bottomIndexPath], with: .top)
				})
			} else {
				onPodcastPressed?(podcast, .save)
			}
		}
		
		return true
	}
}

//MARK: - Convert Helpers
private extension EpisodeTableViewCell.Data {
	init(episode: Episode) {
		image = episode.podcast?.albumArt?.url
		title = episode.title
		subtitle = episode.podcast?.user.profile?.profileFullName ?? ""
	}
	
	init(activity: Activity) {
		image = activity.episode.podcast?.albumArt?.url
		title = activity.episode.title
		subtitle = activity.episode.podcast?.user.profile?.profileFullName ?? ""
		listeningProgress = Float(activity.duration) / Float(activity.episode.duration)
	}
}
