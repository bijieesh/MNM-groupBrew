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
    
    private func initNetworkingStack(with authManager: AppAuthManager) {
        NetworkingStack.instance.update(authManager: authManager, baseUrl: "https://cast.brew.com/api/")
    }

    private func startAuthenticationFlow(with authManager: AppAuthManager) {
        let authCoordinator = AuthenticationCoordinator(rootController: rootController, authManager: authManager)

        authCoordinator.onFinish = { [weak self] in
            guard authManager.isUserLoggedIn else {
                return false
            }

            self?.rootController.dismiss(animated: true) {
                self?.startOnboardingFlow()
            }

            return true
        }

        authCoordinator.start()
    }

    private func startOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(rootController: rootController)
        onboardingCoordinator.onFinish = { [weak self] in

            self?.rootController.dismiss(animated: true) {
                self?.startMainFlow()
            }

            return true
        }
        onboardingCoordinator.start()
    }

    private func startMainFlow() {
        let mainFlowCoordinator = MainFlowCoordinator(rootController: rootController)
        mainFlowCoordinator.start()
    }
}
