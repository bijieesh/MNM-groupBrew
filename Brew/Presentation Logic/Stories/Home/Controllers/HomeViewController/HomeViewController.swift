//
//  HomeViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeViewController: AppViewController {
    @IBOutlet private var popularItemsView: PodcastsListItemView!
    @IBOutlet private var newReleasesItemsView: PodcastsListItemView!
    @IBOutlet private var editorsChoiceItemsView: PodcastsListItemView!
}
