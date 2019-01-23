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

    var onNextTapped: ((_ podcasts: [String]?) -> Void)?

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

    var items: [String] = ["Arts", "Games and hobbies", "Comedy", "Society & Culture", "Education", "Science", "Family"]

    @IBAction private func nextTapped() {
    }
}

extension InterestsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let tag = items[indexPath.row]

        cell.title = tag
        return cell
    }
}
