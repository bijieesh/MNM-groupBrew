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
		case save, delete, select
	}
	
	//MARK: IBOutlets
	@IBOutlet private var topTableView: UITableView! {
		didSet { configureTopTableView() }
	}
	
	@IBOutlet private var bottomTableView: UITableView! {
		didSet { configureBottomTableView() }
	}
	
	@IBOutlet private var showMoreView: UIView!
	@IBOutlet private var oldTableViewHeaderView: UIView!
	
	@IBOutlet private var topReleaseTableViewHeight: NSLayoutConstraint! {
		didSet { topReleaseTableViewHeight.constant = defaultCellHeight * 3 }
	}
	
	@IBOutlet private var seeMoreViewHeight: NSLayoutConstraint!
	
	//MARK: Properties
	private var defaultCellHeight: CGFloat = 128
	
	var topData: [Episode] = [] {
		didSet { topControllerData = topData.map { EpisodeTableViewCell.Data(episode: $0) } }
	}
	
	var bottomData: [Episode] = [] {
		didSet { bottomControllerData = bottomData.map { EpisodeTableViewCell.Data(episode: $0) } }
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
		topReleaseTableViewHeight.constant = defaultCellHeight * CGFloat(topData.count)
		showMoreView.isHidden = true
	}
}

//MARK: - TableView Helpers
private extension EpisodesViewController {
	func handleTopData() {
		showMoreView.isHidden = topData.count < 4
		topTableView.reloadData()
	}
	
	func handleBottomData() {
		oldTableViewHeaderView.isHidden = false
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
			return fillTop(cell, on: tableView, at: indexPath)
		}
		
		return cell
	}
	
	func fillTop(_ cell: EpisodeTableViewCell, on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		let cellData = topControllerData[indexPath.row]
		
		cell.fill(data: cellData)
		
		cell.onSavePressed = {

		}
		
		cell.bottomView.isHidden = true
		
		configureSwipe(for: cell)
		
		return cell
	}
	
	func configureSwipe(for cell: EpisodeTableViewCell) {
		cell.delegate = self
		
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
			: bottomData[indexPath.row]
		
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
			let podcast = bottomData[bottomIndexPath.row]
			
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
		subtitle = episode.podcast?.user.profile.profileFullName ?? ""
		fileIsDownloaded = (episode.file?.url.flatMap { AppFileLoader.shared.localFileUrl(for: $0) }) != nil
	}
}
