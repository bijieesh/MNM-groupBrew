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
    var onProfileImageTapped:OnButtonTapped?
    var updateContent: ((ProfileViewController)-> Void)?
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var podcastsView: PodcastsListView!
    @IBOutlet private var logoImageView: UIImageView! {
        didSet {
            logoImageView.layer.masksToBounds = true
        }
    }
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContent?(self)
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
    @IBAction private func profilePhotoTapped() {
        onProfileImageTapped?(self)
    }
}

extension ProfileViewController {
    func profileImageUpdatedWithNew(_ image: UIImage) {
        logoImageView.image = image
        let resizedImage = image.resizeImage(targetSize: CGSize(width: 24, height: 24))
        if let roundedImage = resizedImage?.circleMasked?.withRenderingMode(.alwaysOriginal) {
            let customTabBarItem = UITabBarItem(title: "Profile", image: roundedImage, selectedImage: roundedImage)
            tabBarItem = customTabBarItem
        }
    }
    
    func updateContent(with user: User) {
        self.user = user
        userNameLabel.text = user.name
        logoImageView.sd_setImage(with: user.profile.profilePicture?.url, completed: nil)
    }
    
    func update(withDiscover discover: [Podcast]) {
        podcastsView?.items = discover.map { $0.listItemData }
    }
}