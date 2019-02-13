//
//  AppFlowCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class AppFlowCoordinator: Coordinator {

    private  lazy var authManager: AppAuthManager = {
        let authManager = AppAuthManager()

        authManager.onLoggedOut = { [weak self] in
            self?.handleAfterLogout()
        }

        initNetworkingStack(with: authManager)
        return authManager
    }()

    override func start() {
        super.start()

        if authManager.isUserLoggedIn {
            startMainFlow()
        }
        else {
            startAuthenticationFlow(with: authManager)
        }
    }
    
    private func logout() {
        authManager.logout(completion: nil)
    }

    private func handleAfterLogout() {

        contentController.dismiss(animated: false) { [weak self] in
            guard let strongSelf = self else {
                return
            }

            self?.startAuthenticationFlow(with: strongSelf.authManager)
        }
    }
    
    private func initNetworkingStack(with authManager: AppAuthManager) {
        NetworkingStack.instance.update(authManager: authManager, baseUrl: "https://cast.brew.com/")
    }

    private func startAuthenticationFlow(with authManager: AppAuthManager) {
        let authCoordinator = AuthenticationCoordinator(authManager: authManager)

        authCoordinator.onLogin = { [weak self] in
            self?.contentController.dismiss(animated: true) {
                self?.startMainFlow()
            }
        }

        authCoordinator.onSignUp = { [weak self] in
            self?.contentController.dismiss(animated: false) {
                self?.startOnboardingFlow()
            }
        }

        contentController.present(authCoordinator.contentController, animated: true)
        authCoordinator.start()
    }

    private func startOnboardingFlow() {
		let navigation = UINavigationController()
        let onboardingCoordinator = OnboardingCoordinator(contentController: navigation)

        onboardingCoordinator.onFinish = { [weak self] in

            self?.contentController.dismiss(animated: false) {
                self?.startMainFlow()
            }
        }

        contentController.present(navigation, animated: true)
        onboardingCoordinator.start()
    }

    private func startMainFlow() {
        let mainFlowCoordinator = MainFlowCoordinator()

        mainFlowCoordinator.onLogout = { [weak self] in
            self?.logout()
        }

        contentController.present(mainFlowCoordinator.contentController, animated: true)
        mainFlowCoordinator.start()
    }
}
