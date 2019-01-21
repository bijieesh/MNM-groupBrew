//
//  AppFlowCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class AppFlowCoordinator {

    private let rootController: UIViewController

    init(rootController: UIViewController) {
        self.rootController = rootController
    }

    func start() {
        let authCoordinator = AuthenticationCoordinator(rootController: rootController)
        authCoordinator.start()
    }
}
