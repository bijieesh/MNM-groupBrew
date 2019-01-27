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

        discoverItemsView?.setup(with: discover)
        popularItemsView?.setup(with: popular)
        newReleasesItemsView?.setup(with: new)
        editorsChoiceItemsView?.setup(with: editors)

        discoverItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
        popularItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
        newReleasesItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
        editorsChoiceItemsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(discover[$0]) }
    }
}
