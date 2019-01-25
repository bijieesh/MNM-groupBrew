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
        self.contentController = contentController
    }
}
