//
//  HomeViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeViewController: AppViewController {
    @IBOutlet private var discoverItemsView: PodcastsListView!
    @IBOutlet private var popularItemsView: PodcastsListView!
    @IBOutlet private var newReleasesItemsView: PodcastsListView!
    @IBOutlet private var editorsChoiceItemsView: PodcastsListView!

    func update(withDiscover discover: [Podcast], popular: [Podcast], new: [Podcast], editors: [Podcast]) {
        discoverItemsView.items = discover.map { $0.listItemData }
        popularItemsView.items = popular.map { $0.listItemData }
        newReleasesItemsView.items = new.map { $0.listItemData }
        editorsChoiceItemsView.items = editors.map { $0.listItemData }
    }
}

private extension Podcast {
    var listItemData: PodcastsListItemView.Data {
        return PodcastsListItemView.Data(title: title, subtitle: description, imageUrl: URL(string: "https://www.wired.com/wp-content/uploads/2015/12/headphones-podcast-business-500850383-blue-f.jpg")!)
    }
}
