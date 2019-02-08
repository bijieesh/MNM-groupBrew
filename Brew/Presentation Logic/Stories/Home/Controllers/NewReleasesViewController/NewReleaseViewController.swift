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
	
	var newReleaseData: [Podcast] = [] {
		didSet {
			showMoreView.isHidden = false
			topReleaseTableView.reloadData()
		}
	}
	
	var oldReleaseData: [Podcast] = [] {
		didSet {
			oldTableViewHeaderView.isHidden = false
		}
	}
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
		let cellData = createData(for: indexPath)
		
		cell.fill(data: cellData)
		
		cell.bottomView.isHidden = true
		
		configureSwipe(for: cell)
		
		return cell
	}
	
	func createData(for indexPath: IndexPath) -> ReleaseTableViewCell.Data {
		let podcastData = newReleaseData[indexPath.row]
		
		return ReleaseTableViewCell.Data(image: podcastData.albumArt?.url,
										 title: podcastData.title,
										 author: podcastData.user.profile.profileFullName)
	}
	
	func configureSwipe(for cell: ReleaseTableViewCell) {
		let rightButton = MGSwipeButton(title: "Save      ", backgroundColor: #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.102151113))
		let leftButton = MGSwipeButton(title: "Skip      ", backgroundColor: #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 0.102151113))
		
		rightButton.setTitleColor(#colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 1), for: .normal)
		leftButton.setTitleColor(#colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1), for: .normal)
		
		cell.delegate = self
		
		cell.rightButtons = [rightButton]
		cell.leftButtons = [leftButton]
		
		cell.leftSwipeSettings.transition = .clipCenter
		cell.leftExpansion.expansionColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 0.1012949486)
		cell.leftExpansion.buttonIndex = 0
		cell.leftExpansion.fillOnTrigger = true
		cell.leftExpansion.threshold = 2
		
		cell.rightSwipeSettings.transition = .clipCenter
		cell.rightExpansion.expansionColor = #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.1012949486)
		cell.rightExpansion.buttonIndex = 0
		cell.rightExpansion.fillOnTrigger = true
		cell.rightExpansion.threshold = 2
	}
	
	func deleteRow<T, U: UITableView>(from data: inout[T], for tableView: U, at indexPath: IndexPath) {
		tableView.beginUpdates()
		data.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .top)
		tableView.endUpdates()
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
		
	}
}

//MARK: - MGSwipeTableCellDelegate
extension NewReleaseViewController: MGSwipeTableCellDelegate {
	func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
		let topIndexPath = topReleaseTableView.indexPath(for: cell)
		let bottomIndexPath = bottomReleaseTableView.indexPath(for: cell)
		
		if let topIndexPath = topIndexPath {
			topReleaseTableView.performBatchUpdates({
				newReleaseData.remove(at: topIndexPath.row)
				topReleaseTableView.deleteRows(at: [topIndexPath], with: .top)
			})
		}
		
		if let bottomIndexPath = bottomIndexPath {
			bottomReleaseTableView.performBatchUpdates({
				oldReleaseData.remove(at: bottomIndexPath.row)
				bottomReleaseTableView.deleteRows(at: [bottomIndexPath], with: .top)
			})
		}

		return true
	}
}
