//
//  ProfileViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class ProfileViewController: AppViewController {
    
    typealias OnButtonTapped = ((_ on: ProfileViewController)->Void)
    var onBackTapped:OnButtonTapped?
    var onSettingsTapped:OnButtonTapped?
    var onLogOutTapped:OnButtonTapped?

    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var podcastsView: PodcastsListView!
    @IBOutlet private var logoImageView: UIImageView! {
        didSet {
            logoImageView.layer.masksToBounds = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func backTapped() {
        onBackTapped?(self)
    }
    @IBAction private func settingsTapped() {
        onSettingsTapped?(self)
    }
    @IBAction private func logOutTapped() {
        onLogOutTapped?(self)
    }
}
