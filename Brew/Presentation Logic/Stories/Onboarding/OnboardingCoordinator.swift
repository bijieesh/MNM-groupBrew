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
        rootController.topController.present(interestsViewController, animated: false)
    }

    private func showInterests() {
        let interestsViewController = InterestsViewController()
        rootController.topController.present(interestsViewController, animated: false)
    }

    private func showPriceSelection() {
        let priceViewController = PriceViewController()
        rootController.topController.present(priceViewController, animated: false)
    }
}
