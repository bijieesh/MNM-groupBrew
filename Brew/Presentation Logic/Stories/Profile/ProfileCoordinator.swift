//
//  ProfileCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {

    private(set) var contentController: UINavigationController?
    private var user: User?

    override func start() {
        super.start()
        setupProfileController()
    }

    private func setupProfileController() {
        let profileController = ProfileViewController()
        let contentController = UINavigationController(rootViewController: profileController)
        contentController.isNavigationBarHidden = true

        profileController.onProfileImageTapped = { [weak self, profileController] in
            self?.showImagePicker(from: profileController)
        }

        profileController.onSettingsTapped = { [weak self, profileController] in
            self?.showProfileSettings(onContentUpdated: { [weak self, profileController] in
                self?.loadUserInfo(for: profileController)
            })
        }

        profileController.onLogOutTapped = { [weak self] in
            self?.logout()
        }
    
        self.loadUserInfo(for: profileController)
        self.contentController = contentController
    }
}

private extension ProfileCoordinator {

    func showImagePicker(from controller: ProfileViewController) {
        ImagePickerCoordinator().showImagePicker(for: controller) { image in
            guard let image = image else { return }
            controller.updateProfileImage(with: image)
        }
    }
    
    func showProfileSettings(onContentUpdated: @escaping () -> Void) {
        let settingsViewController = SettingsViewController()
        
        settingsViewController.onClose = { [weak self] in
            self?.contentController?.popViewController(animated: true)
        }
        
        settingsViewController.onChangePassword = { [weak self, settingsViewController] (oldPassword, newPassword) in
            self?.change(oldPassword, with: newPassword, on: settingsViewController)
        }
        
        settingsViewController.onUpdateProfile = { [weak self, settingsViewController] (fullname, email, mobile, country) in
            self?.updateProfileInfo(fullname: fullname, email: email, mobile: mobile, country: country) { success in
                guard success else {
                    return
                }

                settingsViewController.profileUpdated()
                onContentUpdated()
            }
        }
        
        settingsViewController.user = user
    
        contentController?.pushViewController(settingsViewController, animated: true)
    }
    
    func loadUserInfo(for controller: ProfileViewController) {
        GetCurrentUserRequest().execute(

            onSuccess: { [weak self] user in
                self?.user = user
                controller.updateContent(with: user)
        },

            onError: { error in
                error.display()
        })
    }
    
    func change(_ oldPassword: String, with newPassword: String, on controller: SettingsViewController) {
        let changePasswordReques = ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword)
        changePasswordReques.execute(

            onSuccess: { user in
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
    
    func updateProfileInfo(fullname: String, email: String, mobile: String?, country: String, completion: ((Bool)-> Void)? = nil) {

        UpdateProfileInfoRequest(fullname: fullname, email: email, mobile: mobile, country: country).execute(

            onSuccess: { user in
                completion?(true)
        },
            onError: { error in
                error.display()
                completion?(false)
        })
    }
    
    func logout() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.logout()
        }
    }
}
