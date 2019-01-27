//
//  ProfileCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {

    private(set) var contentController: UIViewController?

    override func start() {
        super.start()

        let profileController = ProfileViewController()
        let contentController = UINavigationController(rootViewController: profileController)
        contentController.isNavigationBarHidden = true
        
        profileController.onProfileImageTapped = { [weak self] controller in
            self?.showImagePickerFrom(controller)
        }
        
        profileController.onSettingsTapped = { [weak self] controller in
            self?.showSettingsViewControllerFrom(controller)
        }
        
        profileController.onLogOutTapped = { [weak self] controller in
            self?.logout()
        }
        
        profileController.updateContent = { [weak self] controller in
            self?.loadUserInfo(for: controller)
        }
        
        self.contentController = contentController
    
        loadProfileContent(for: profileController)
    }
}

private extension ProfileCoordinator {
    func showImagePickerFrom(_ controller: ProfileViewController) {
        ImagePickerCoordinator.shared.showImagePicker(for: controller) { image in
            guard let image = image else { return }
            controller.profileImageUpdatedWithNew(image)
        }
    }
    
    func showSettingsViewControllerFrom(_ controller: ProfileViewController) {
        let settingsViewController = SettingsViewController()
        
        settingsViewController.onBackTapped = { controller in
            controller.navigationController?.popViewController(animated: true)
        }
        
        settingsViewController.onChangePassword = { [weak self] (controller, oldPassword, newPassword) in
            self?.change(oldPassword: oldPassword, with: newPassword, on: controller)
        }
        
        settingsViewController.onUpdateProfile = { [weak self] (controller, fullname, email, mobile, country) in
            self?.updateProfileInfo(fullname: fullname, email: email, mobile: mobile, country: country, on: controller)
        }
        
        settingsViewController.user = controller.user
    
        controller.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func loadUserInfo(for controller: ProfileViewController) {
        GetCurrentUserRequest().execute(onSuccess: { user in
            controller.updateContent(with: user)
        }) { error in
            error.display()
        }
    }
    
    func loadProfileContent(for controller: ProfileViewController) {
        var discoverPodcasts: [Podcast] = []

        GetPodcastsRequest(type: .discover).execute(onSuccess: {
            discoverPodcasts = $0
            controller.update(withDiscover: discoverPodcasts)
        })
    }
    
    func change(oldPassword: String, with newPassword: String, on controller: SettingsViewController) {
        let changePasswordReques = ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword)
        changePasswordReques.execute(onSuccess: { user in
            controller.clearPasswordFields()
        },
        onError: { error in
            if case let .custom(_, statusCode) = error, statusCode.isUnauthorize {
                controller.markInvalid()
            }
            else {
                error.display()
            }
        })
    }
    
    func updateProfileInfo(fullname: String, email: String, mobile: String?, country: String, on controller: SettingsViewController) {
        UpdateProfileInfoRequest(fullname: fullname, email: email, mobile: mobile, country: country).execute(onSuccess: { user in
            controller.profileUpdated()
        }, onError: { error in
            error.display()
        })
    }
    
    func logout() {

    }
}
