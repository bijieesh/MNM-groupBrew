//
//  OnboardingCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/23/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator {

    override func start() {
        super.start()

        let interestsViewController = InterestsViewController()
        rootController.present(interestsViewController, animated: false)
    }
}
