//
//  SearchViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class SearchViewController: UIViewController {
	typealias Action = () -> Void
	typealias SearchAction = (String) -> Void
	typealias CategoryAction = (Category) -> Void
	
	@IBOutlet private var searchBar: UISearchBar!
	@IBOutlet private var collectionView: UICollectionView! {
		didSet { configureCollectionView() }
	}
	
	var onCategory: CategoryAction?
	var onTopPodcast: Action?
	var onEditorsChoice: Action?
	var onSearch: SearchAction?
	var onNeedUpdate: Action?
	
	var data: [Category] = [] {
		didSet { fillData() }
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		onNeedUpdate?()
		setupNavigationController()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		configureCollectionViewLayout()
	}
}

//MARK: - Controller Helpers
private extension SearchViewController {
	func fillData() {
		collectionView.reloadData()
	}
	
	func setupNavigationController() {
		navigationItem.title = "Search"
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
		navigationController?.navigationBar.prefersLargeTitles = true
	}
}

//MARK: - CollectionView Helpers
private extension SearchViewController {
	func configureCollectionView() {
		collectionView.register(supplementaryViewType: SearchHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
		collectionView.register(cellType: CategoryCollectionViewCell.self)
	}
	
	func configureCollectionViewLayout() {
		let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
		let columns: CGFloat = 2
		let minimumInteritemSpacing: CGFloat = 20
		let width = (collectionView.frame.width - minimumInteritemSpacing) / columns
		let height: CGFloat = width
		
		layout?.itemSize = CGSize(width: width, height: height)
		layout?.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 200)
		layout?.minimumInteritemSpacing = minimumInteritemSpacing
		layout?.minimumLineSpacing = 20
		
		collectionView.reloadData()
	}
	
	func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
		let cellData = data[indexPath.row]
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
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: SearchHeaderView.self)
			
			headerView.onTopPodcast = { [weak self] in
				self?.onTopPodcast?()
			}
			
			headerView.onEditorsChoice = { [weak self] in
				self?.onEditorsChoice?()
			}
			
			return headerView
		}
		
		return UICollectionReusableView()
	}
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = data[indexPath.row]
		onCategory?(category)
	}
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
		
		if let searchText = searchBar.text, !searchText.isEmpty {
			onSearch?(searchText)
		}
	}
}
