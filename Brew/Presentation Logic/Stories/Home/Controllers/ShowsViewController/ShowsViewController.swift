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
	typealias IndexAction = (Int) -> Void
	
	@IBOutlet private var collectionView: UICollectionView! {
		didSet { configureCollectionView() }
	}
	
	var onPodcastPressed: IndexAction?
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureCollectionViewLayout()
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
		let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.image = URL(string: "https://blog.algolia.com/wp-content/uploads/2016/04/podcast.png")
		
		return cell
	}
}

//MARK: - UICollectionViewDataSource
extension ShowsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return configureCell(for: collectionView, at: indexPath)
	}
}

//MARK: - UICollectionViewDelegate
extension ShowsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		onPodcastPressed?(indexPath.item)
	}
}
