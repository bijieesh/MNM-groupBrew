//
//  ProfileCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class ProfileCoordinator: NavigationCoordinator {

    var onLogout: (() -> Void)?
    var onNeedPlayPodcast: ((Podcast, Int) -> Void)?

    private var user: User?

    private let imagePickerCoordinator = ImagePickerCoordinator()

    override func start() {
        super.start()
        setupProfileController()
    }

    private func setupProfileController() {
        let profileController = ProfileViewController()
		
		profileController.onGetData = { [weak self, weak profileController] in
			self?.loadUserInfo(for: profileController)
		}

		profileController.onProfileImage = { [weak self, weak profileController] in
            self?.showImagePicker(from: profileController)
        }

        profileController.onSettings = { [weak self, weak profileController] in
            self?.showProfileSettings(onContentUpdated: { [weak self, profileController] in
                self?.loadUserInfo(for: profileController)
            })
        }

        profileController.onLogOut = { [weak self] in
            self?.logout()
        }
        
        profileController.onPodcast = { [weak self] in
            self?.showPodcastDetails(for: $0)
        }
    
        navigationController?.pushViewController(profileController, animated: false)
    }
}

private extension ProfileCoordinator {

    func showImagePicker(from controller: ProfileViewController?) {
        imagePickerCoordinator.showImagePicker(for: controller) { image in
            guard let image = image else { return }
            controller?.updateProfileImage(with: image)
        }
    }
    
    func showProfileSettings(onContentUpdated: @escaping () -> Void) {
        let settingsViewController = SettingsViewController()
        
        settingsViewController.onClose = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
    
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func loadUserInfo(for controller: ProfileViewController?) {
        GetCurrentUserRequest().execute(

            onSuccess: { user in
                controller?.user = user
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
        onLogout?()
    }
    
    func showPodcastDetails(for podcast: Podcast) {
        let controller = PodcastDetailViewController()
        controller.podcast = podcast
        
        controller.onBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        controller.onPodcast = { [weak self] in
            self?.onNeedPlayPodcast?($0, $1)
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
