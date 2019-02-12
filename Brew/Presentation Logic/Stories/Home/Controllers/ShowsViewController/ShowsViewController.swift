//
//  ShowsViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/7/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class ShowsViewController: AppViewController {
	typealias PodcastAction = (Podcast) -> Void

	@IBOutlet private var collectionView: UICollectionView! {
		didSet { configureCollectionView() }
	}
	
	var onPodcastPressed: PodcastAction?
	
	var data: [Podcast] = [] {
		didSet { collectionView.reloadData() }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureBackButton()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureCollectionViewLayout()
	}
}

//MARK: - ControllerHelers
private extension ShowsViewController {
	func configureBackButton() {
		let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back.pdf"), style: .plain, target: self, action: #selector(backButtonPressed))
		backButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		navigationItem.leftBarButtonItem = backButton
	}
	
	@objc func backButtonPressed() {
		onClose?()
	}
}

//MARK: - CollectionView Helpers
private extension ShowsViewController {
	func configureCollectionView() {
		collectionView.register(cellType: ImageCollectionViewCell.self)
	}

	func configureCollectionViewLayout() {
		let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
		let columns: CGFloat = 2
		let minimumInteritemSpacing: CGFloat = 30
		let width = (collectionView.frame.width - minimumInteritemSpacing) / columns
		let height: CGFloat = width
		
		layout?.itemSize = CGSize(width: width, height: height)
		layout?.minimumInteritemSpacing = minimumInteritemSpacing
		layout?.minimumLineSpacing = 20
		
		collectionView.reloadData()
	}
	
	func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
		let cellData = data[indexPath.item]
		let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
		
		cell.image = cellData.albumArt?.url
		
		return cell
	}
}

//MARK: - UICollectionViewDataSource
extension ShowsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return configureCell(for: collectionView, at: indexPath)
	}
}

//MARK: - UICollectionViewDelegate
extension ShowsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let podcast = data[indexPath.item]
		onPodcastPressed?(podcast)
	}
}
