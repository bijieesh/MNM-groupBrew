//
//  InterestsViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import Reusable
import AlignedCollectionViewFlowLayout

class InterestsViewController: AppViewController {

    var onNextTapped: ((_ selected: [Category]) -> Void)?

    @IBOutlet private var collectionViewLayout: AlignedCollectionViewFlowLayout! {
        didSet {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            collectionViewLayout.minimumInteritemSpacing = 20
            collectionViewLayout.horizontalAlignment = .left
        }
    }

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView?.register(cellType: TagViewCell.self)
            collectionView.allowsMultipleSelection = true
        }
    }

    var categories: [Category] = []

    @IBAction private func nextTapped() {
        let selected = collectionView.indexPathsForSelectedItems?.map({ categories[$0.row] }) ?? []
        onNextTapped?(selected)
    }
}

extension InterestsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let tag = categories[indexPath.row].name
        cell.title = tag
        return cell
    }
}
