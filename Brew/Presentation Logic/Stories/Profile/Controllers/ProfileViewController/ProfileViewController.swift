//
//  ProfileViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: AppViewController {
    
    typealias OnButtonTapped = ((_ on: ProfileViewController)->Void)
    
    var onBackTapped:OnButtonTapped?
    var onSettingsTapped:OnButtonTapped?
    var onLogOutTapped:OnButtonTapped?
    var onProfileImageTapped:OnButtonTapped?
    var updateContent: ((ProfileViewController)-> Void)?
    
    //MARK: IBOutlets
    
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var podcastsView: PodcastsListView!
    @IBOutlet private var logoImageView: UIImageView! {
        didSet {
            logoImageView.layer.masksToBounds = true
        }
    }
    
    var user: User?

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInfo()
    }
    
    //MARK: IBActions
    
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
        setupTabBarImage(image)
    }
    
    func updateContent(with user: User) {
        self.user = user
        
        userNameLabel?.text = user.profile.profileFullName
        update(withPodcasts: user.podcasts ?? [])
        
        guard let userProfilePictureUrl = user.profile.profilePicture?.url else {
            setupTabBarImage(UIImage(named: "icon-profile") ?? UIImage())
            return
        }
    
        SDWebImageManager.shared().loadImage(with: userProfilePictureUrl, options: .highPriority, progress: nil) { [weak self] (image, _, _, _, _, _) in
            guard let image = image else { return }
            self?.logoImageView?.image = image
            self?.setupTabBarImage(image)
        }
    }
    
    func update(withPodcasts podcasts: [Podcast]) {
        podcastsView?.items = podcasts.map { $0.listItemData }
    }
}

private extension ProfileViewController {
    func setupTabBarImage(_ image: UIImage) {
        let resizedImage = image.resizeImage(targetSize: CGSize(width: 24, height: 24))
        if let roundedImage = resizedImage?.circleMasked?.withRenderingMode(.alwaysOriginal) {
            let customTabBarItem = UITabBarItem(title: "Profile", image: roundedImage, selectedImage: roundedImage)
            tabBarItem = customTabBarItem
        }
    }
    
    private func setupUserInfo() {
        if let user = self.user {
            updateContent(with: user)
        }
    }
}
