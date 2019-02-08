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

class NewReleaseViewController: UIViewController {
	typealias PodcastAction = (_ controllerType: ControllerType, _ podcastType: DataType, _ actionType: ActionType, _ index: Int) -> Void
	
	enum ControllerType {
		case new, saved
	}
	
	enum DataType {
		case new, old
	}
	
	enum ActionType {
		case leftAction, rightAction, select
	}
	
	//MARK: IBOutlets
	@IBOutlet private var topReleaseTableView: UITableView! {
		didSet { configureTopReleaseTableView() }
	}
	
	@IBOutlet private var bottomReleaseTableView: UITableView! {
		didSet { configureBottomReleaseTableView() }
	}
	
	@IBOutlet private var showMoreView: UIView!
	@IBOutlet private var oldTableViewHeaderView: UIView!
	
	@IBOutlet private var topReleaseTableViewHeight: NSLayoutConstraint! {
		didSet { topReleaseTableViewHeight.constant = defaultCellHeight * 3 }
	}
	
	@IBOutlet private var seeMoreViewHeight: NSLayoutConstraint!
	
	//MARK: Properties
	private var defaultCellHeight: CGFloat = 128
	
	var newReleaseData: [ReleaseTableViewCell.Data] = [] {
		didSet { handleNewReleaseData() }
	}
	
	var oldReleaseData: [ReleaseTableViewCell.Data] = [] {
		didSet { handleOldReleaseData() }
	}
	
	var controllerType: ControllerType!
	var onPodcastPressed: PodcastAction?
}

//MARK: - @IBAction
private extension NewReleaseViewController {
	@IBAction func onSeeMorePressed() {
		topReleaseTableViewHeight.constant = defaultCellHeight * CGFloat(newReleaseData.count)
		showMoreView.isHidden = true
	}
}

//MARK: - TableView Helpers
private extension NewReleaseViewController {
	func handleNewReleaseData() {
		showMoreView.isHidden = newReleaseData.count < 4
		topReleaseTableView.reloadData()
	}
	
	func handleOldReleaseData() {
		oldTableViewHeaderView.isHidden = false
	}
	
	func configureTopReleaseTableView() {
		topReleaseTableView.register(cellType: ReleaseTableViewCell.self)
	}
	
	func configureBottomReleaseTableView() {
		bottomReleaseTableView.register(cellType: ReleaseTableViewCell.self)
	}
	
	func fillCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell: ReleaseTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		
		if tableView == topReleaseTableView {
			return fillRelease(cell, on: tableView, at: indexPath)
		}
		
		return cell
	}
	
	func fillRelease(_ cell: ReleaseTableViewCell, on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		let cellData = newReleaseData[indexPath.row]
		
		cell.fill(data: cellData)
		
		cell.onSavePressed = { }
		
		cell.bottomView.isHidden = true
		
		configureSwipe(for: cell)
		
		return cell
	}
	
	func configureSwipe(for cell: ReleaseTableViewCell) {
		let rightButton = MGSwipeButton(title: "", backgroundColor: #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.102151113))
		cell.rightButtons = [rightButton]
		cell.rightSwipeSettings.transition = .clipCenter
		cell.rightExpansion.expansionColor = #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.1012949486)
		cell.rightExpansion.buttonIndex = 0
		cell.rightExpansion.fillOnTrigger = true
		cell.rightExpansion.threshold = 2
		
		cell.delegate = self
		
		if controllerType == .new {
			let leftButton = MGSwipeButton(title: "Skip      ", backgroundColor: #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 0.102151113))
			leftButton.setTitleColor(#colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1), for: .normal)
			cell.leftButtons = [leftButton]
			cell.leftSwipeSettings.transition = .clipCenter
			cell.leftExpansion.expansionColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 0.1012949486)
			cell.leftExpansion.buttonIndex = 0
			cell.leftExpansion.fillOnTrigger = true
			cell.leftExpansion.threshold = 2
			
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
			cell.rightExpansion.threshold = 2		}
	}
}

//MARK: UITableViewDataSource
extension NewReleaseViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableView == topReleaseTableView ? newReleaseData.count : oldReleaseData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.fillCell(for:tableView, indexPath: indexPath)
	}
}

//MARK: - UITableViewDelegate
extension NewReleaseViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let type: DataType = tableView == topReleaseTableView ? .new : .old

		onPodcastPressed?(controllerType, type, .select, indexPath.row)
	}
}

//MARK: - MGSwipeTableCellDelegate
extension NewReleaseViewController: MGSwipeTableCellDelegate {
	func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
		let topIndexPath = topReleaseTableView.indexPath(for: cell)
		let bottomIndexPath = bottomReleaseTableView.indexPath(for: cell)
		
		if let topIndexPath = topIndexPath {
			if direction == .leftToRight {
				onPodcastPressed?(controllerType, .new, .leftAction, topIndexPath.row)
				
				topReleaseTableView.performBatchUpdates({
					newReleaseData.remove(at: topIndexPath.row)
					topReleaseTableView.deleteRows(at: [topIndexPath], with: .top)
				})
			} else {
				if controllerType == .saved {
					topReleaseTableView.performBatchUpdates({
						newReleaseData.remove(at: topIndexPath.row)
						topReleaseTableView.deleteRows(at: [topIndexPath], with: .top)
					})
				}
				
				onPodcastPressed?(controllerType, .new, .rightAction, topIndexPath.row)
			}
		}
		
		if let bottomIndexPath = bottomIndexPath {
			if direction == .leftToRight {
				onPodcastPressed?(controllerType, .old, .leftAction, bottomIndexPath.row)
				
				bottomReleaseTableView.performBatchUpdates({
					oldReleaseData.remove(at: bottomIndexPath.row)
					bottomReleaseTableView.deleteRows(at: [bottomIndexPath], with: .top)
				})
			} else {
				if controllerType == .saved {
					bottomReleaseTableView.performBatchUpdates({
						oldReleaseData.remove(at: bottomIndexPath.row)
						bottomReleaseTableView.deleteRows(at: [bottomIndexPath], with: .top)
					})
				}
				
				onPodcastPressed?(controllerType, .old, .rightAction, bottomIndexPath.row)
			}
		}

		return true
	}
}

