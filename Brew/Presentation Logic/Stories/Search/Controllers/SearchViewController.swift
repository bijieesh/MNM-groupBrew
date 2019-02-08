//
//  SearchViewController.swift
//  Brew
//
//  Created by Admin on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

class SearchViewController: UIViewController {

	typealias IndexAction = (Int) -> Void
	
	@IBOutlet private var collectionView: UICollectionView! {
		didSet {
			configureCollectionView()
		}
	}
	
	var onCategorytPressed: IndexAction?
	var data: [Category] = []
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureCollectionViewLayout()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

//MARK: - CollectionView Helpers
private extension SearchViewController {
	func configureCollectionView() {
		collectionView.register(cellType: CategoryCollectionViewCell.self)
	}
	
	func configureCollectionViewLayout() {
		let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
		let columns: CGFloat = 2
		let minimumInteritemSpacing: CGFloat = 20
		let width = (collectionView.frame.width - minimumInteritemSpacing) / columns
		let height: CGFloat = width
		
		layout?.itemSize = CGSize(width: width, height: height)
		layout?.minimumInteritemSpacing = minimumInteritemSpacing
		layout?.minimumLineSpacing = 20
		
		collectionView.reloadData()
	}
	
	func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
		let cellData = data[indexPath.item]
		let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
		
		cell.title = cellData.name
		cell.image = cellData.file?.url
		
		return cell
	}
}

//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return data.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return configureCell(for: collectionView, at: indexPath)
	}
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		onCategorytPressed?(indexPath.item)
	}
}
