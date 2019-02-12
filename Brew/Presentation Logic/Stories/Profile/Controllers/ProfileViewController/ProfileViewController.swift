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

    var onSettingsTapped: (() -> Void)?
    var onLogOutTapped: (() -> Void)?
    var onProfileImageTapped: (() -> Void)?
    var onPodcastSelected: ((Podcast) -> Void)?
    
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
        updateUI()
    }
    
    //MARK: IBActions

    @IBAction private func settingsTapped() {
        onSettingsTapped?()
    }
    @IBAction private func logOutTapped() {
        onLogOutTapped?()
    }
    @IBAction private func profilePhotoTapped() {
        onProfileImageTapped?()
    }
}

extension ProfileViewController {

    func updateProfileImage(with image: UIImage) {
        logoImageView.image = image
        setupTabBarImage(image)
    }


    func updateContent(with user: User) {
        self.user = user
        updateUI()
    }

    private func updateUI() {
        guard isViewLoaded else {
            return
        }

        userNameLabel?.text = user?.profile?.profileFullName

        setupPodcasts()
        setupAvatarFromUser()
    }

    private func setupPodcasts() {
        let podcasts = user?.podcasts ?? []
        podcastsView?.setup(with: podcasts)
        podcastsView?.onItemSelected = { [weak self] in self?.onPodcastSelected?(podcasts[$0]) }
    }

    private func setupAvatarFromUser() {
        guard let userProfilePictureUrl = user?.profile?.profilePicture?.url else {
            return
        }

        SDWebImageManager.shared().loadImage(with: userProfilePictureUrl, options: .highPriority, progress: nil) { [weak self] (image, _, _, _, _, _) in
            guard let image = image else { return }
            self?.updateProfileImage(with: image)
        }
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
}
