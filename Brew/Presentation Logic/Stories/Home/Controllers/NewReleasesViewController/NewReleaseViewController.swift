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
		didSet { topReleaseTableView.register(cellType: ReleaseTableViewCell.self) }
	}
	
	@IBOutlet private var bottomReleaseTableView: UITableView! {
		didSet { bottomReleaseTableView.register(cellType: ReleaseTableViewCell.self) }
	}
	
	@IBOutlet private var topReleaseTableViewHeight: NSLayoutConstraint!
	@IBOutlet private var seeMoreButton: UIButton!
	@IBOutlet private var seeMoreViewHeight: NSLayoutConstraint!
	
	//MARK: Properties
	
	private var defaultCellHeight: CGFloat = 128
	
	var newReleaseData = [1, 2, 3, 4]
	var oldReleaseData = [1, 2]
	
	//MARK: Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topReleaseTableViewHeight.constant = defaultCellHeight * 3
	}
	
	
	private func fillCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell: ReleaseTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		
		if tableView == topReleaseTableView {
			cell.bottomView.isHidden = true
			cell.delegate = self as MGSwipeTableCellDelegate
			
			let rightButton = MGSwipeButton(title: "Save      ", backgroundColor: #colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 0.102151113))
			rightButton.setTitleColor(#colorLiteral(red: 0.2823529412, green: 0.7529411765, blue: 0.6196078431, alpha: 1), for: .normal)
			let leftButton = MGSwipeButton(title: "Skip      ", backgroundColor: #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 0.102151113))
			leftButton.setTitleColor(#colorLiteral(red: 1, green: 0.3490196078, blue: 0.3490196078, alpha: 1), for: .normal)
			
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
			
		} else if tableView == bottomReleaseTableView {
			
		}
		
		
		return cell ?? UITableViewCell()
	}
	
	//MARK: Actions
	
	@IBAction func onSeeMorePressed(_ sender: Any) {
		topReleaseTableViewHeight.constant = defaultCellHeight * CGFloat(newReleaseData.count)
		seeMoreButton.isHidden = true
		seeMoreViewHeight.constant = 82
	}
	
	func skip() {
		
	}
	
	func save() {
		
	}
}

//MARK: UITableViewDataSource

extension NewReleaseViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if tableView == topReleaseTableView {
			return newReleaseData.count
			
		} else if tableView == bottomReleaseTableView {
			return oldReleaseData.count
		}
		
		return 0
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
		switch index {
		case 0:  // skip
			skip()
		case 1:  // save
			save()
		default:
			break
		}
		
		return true
	}
}
