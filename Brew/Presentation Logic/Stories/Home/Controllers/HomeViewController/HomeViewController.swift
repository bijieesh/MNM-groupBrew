//
//  HomeViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeViewController: AppViewController {

    var onPodcastSelected: ((Podcast) -> Void)?

    @IBOutlet private var discoverItemsView: PodcastsListView!
    @IBOutlet private var popularItemsView: PodcastsListView!
    @IBOutlet private var newReleasesItemsView: PodcastsListView!
    @IBOutlet private var editorsChoiceItemsView: PodcastsListView!

    func update(withDiscover discover: [Podcast], popular: [Podcast], new: [Podcast], editors: [Podcast]) {

        discoverItemsView?.items = discover.map { $0.listItemData }
        popularItemsView?.items = popular.map { $0.listItemData }
        newReleasesItemsView?.items = new.map { $0.listItemData }
        editorsChoiceItemsView?.items = editors.map { $0.listItemData }

        discoverItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
        popularItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
        newReleasesItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
        editorsChoiceItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
    }
}

extension Podcast {
    var listItemData: PodcastsListItemView.Data {
        return PodcastsListItemView.Data(title: title, subtitle: description)
    }
}
