//
//  PaymentScene.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/15/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class PaymentScene {
	typealias Action = () -> Void

    var onFinish: Action?

    private(set) lazy var controller: UIViewController = {
        let priceViewController = PriceViewController()

        priceViewController.onLaterTapped = { [weak self] in
            self?.onFinish?()
        }

        priceViewController.onPurchase = { [weak self] in
            switch $0 {
            case .small: self?.purchase(.smallPriceSubscription)
            case .medium: self?.purchase(.mediumPriceSubscription)
            case .high: self?.purchase(.highPriceSubscription)
            }
        }

        return priceViewController
    }()

    private func purchase(_ feature: FeatureManager.Feature) {
        feature.purchase { [weak self] _ in
            self?.onFinish?()
        }
    }
}
