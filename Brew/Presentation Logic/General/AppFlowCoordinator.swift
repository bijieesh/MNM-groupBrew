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
        let authCoordinator = AuthenticationCoordinator(rootController: rootController)
        authCoordinator.start()
    }

    private func startAuthenticationFlow() {
        let authCoordinator = AuthenticationCoordinator(rootController: rootController)

        authCoordinator.start()
    }
}
