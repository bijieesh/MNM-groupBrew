//
//  AppFlowCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class AppFlowCoordinator: Coordinator {

    override func start() {
        super.start()
        let authManager = AppAuthManager()

        initNetworkingStack(with: authManager)

        if authManager.isUserLoggedIn {
            startMainFlow()
        }
        else {
            startAuthenticationFlow(with: authManager)
        }
    }
    
    private func logout() {
        let authManager = AppAuthManager()
        initNetworkingStack(with: authManager)
        
        authManager.logout { [weak self] success in
            guard success else {
                return
            }
            self?.contentController.dismiss(animated: false) {
                self?.startAuthenticationFlow(with: authManager)
            }
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
        let onboardingCoordinator = OnboardingCoordinator()

        onboardingCoordinator.onFinish = { [weak self] in

            self?.contentController.dismiss(animated: false) {
                self?.startMainFlow()
            }
        }

        contentController.present(onboardingCoordinator.contentController, animated: true)
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
