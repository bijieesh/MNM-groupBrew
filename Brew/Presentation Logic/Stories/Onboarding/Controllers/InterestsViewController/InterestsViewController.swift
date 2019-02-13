//
//  InterestsViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable

final class InterestsViewController: AppViewController {
	typealias PodcastArrayAction = ([Podcast]) -> Void
	typealias Action = () -> Void
	
    var onNext: PodcastArrayAction?
	var onSkip: Action?

    @IBOutlet private var collectionView: UICollectionView! {
        didSet { configureCollectionView() }
    }
	
	var podcasts: [Podcast] = [] {
		didSet { collectionView.reloadData() }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureCollectionViewLayout()
	}
}

//MARK: - Controller Helpers
private extension InterestsViewController {
	@IBAction func nextTapped() {
		let selectedPodcasts = collectionView.indexPathsForSelectedItems?.map({ podcasts[$0.item] }) ?? []
		onNext?(selectedPodcasts)
	}
	
	@IBAction func skipTapped() {
		onSkip?()
	}
	
	func configureCollectionView() {
		collectionView?.register(cellType: ImageCollectionViewCell.self)
		collectionView.allowsMultipleSelection = true
	}
	
	func configureCollectionViewLayout() {
		let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
		let columns: CGFloat = 3
		let width = collectionView.frame.width / columns
		let height: CGFloat = width
		
		layout?.itemSize = CGSize(width: width, height: height)
		layout?.minimumInteritemSpacing = 0
		layout?.minimumLineSpacing = 0
		
		collectionView.reloadData()
	}
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension InterestsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ImageCollectionViewCell.self)
		
		cell.image = podcasts[indexPath.item].albumArt?.url
		
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		cell.isSelected = !cell.isSelected
	}
}

