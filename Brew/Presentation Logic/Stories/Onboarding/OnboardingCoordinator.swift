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

        showInterests()
    }

    private func showInterests() {

        GetAllCategoriesRequest().execute(
            onSuccess: { [weak self] in
                self?.showInterests(with: $0)
        },

            onError: { error in
                error.display()
        })
    }

    private func showInterests(with categories: [Category]) {
        let interestsViewController = InterestsViewController()

        interestsViewController.categories = categories

        interestsViewController.onNextTapped = { [weak self] selected in
            self?.showPriceSelection()
        }

        rootController.topController.present(interestsViewController, animated: false)
    }

    private func showPriceSelection() {
        let priceViewController = PriceViewController()

        priceViewController.onLaterTapped = { [weak self] in self?.end() }
        priceViewController.onNextTapped = { [weak self] in self?.end() }

        rootController.topController.present(priceViewController, animated: false)
    }
}
