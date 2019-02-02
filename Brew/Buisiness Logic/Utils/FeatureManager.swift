//
//  FeatureManager.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/29/18.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation
import RMStore

class FeatureManager: NSObject, RMStoreObserver {
    static let shared = FeatureManager()
    
    func prepare() {
        RMStore.default().add(self)
        RMStore.default().restoreTransactions()
    }
    
    func restorePurchases(with callback: ((_ restored: Bool) -> Void)? = nil) {
        RMStore.default().restoreTransactions(
            onSuccess: { _ in
                callback?(true)
        },
            failure: { _ in
                callback?(false)
        })


    }
    
    func fetchAvailability(with completion: @escaping ((_ available: [Feature], _ unavailable: [Feature]) -> Void)) {
        let featureIds = [
            Feature.lowPriceSubscription,
            Feature.mediumPriceSubscription,
            Feature.highPriceSubsription
        ]
        
        RMStore.default().requestProducts(Set(featureIds),
                                          success: { (products, invalidProductIds) in
                                            
                                            var available: [Feature] = []
                                            var unavailable: [Feature] = []
                                            
                                            if let skProducts = products as? [SKProduct] {
                                                available = skProducts.compactMap({ Feature(rawValue: $0.productIdentifier) })
                                            }
                                            
                                            if let unavailableStrings = invalidProductIds as? [String] {
                                                unavailable = unavailableStrings.compactMap({ Feature(rawValue: $0) })
                                            }
                                            
                                            completion(available, unavailable)
        },
                                          failure: { _ in
                                            completion([], [])
        })
    }
    
    func purchase(_ feature: Feature, with callback: ((_ success: Bool) -> Void)? = nil) {
        RMStore.default().addPayment(feature.rawValue,
                                     success: { _ in
                                        feature.store()
                                        callback?(true)
        },
                                     failure: { (_, _) in
                                        callback?(false)
        })
    }

    func storePaymentTransactionFinished(_ notification: Notification!) {
        guard let transaction = (notification as NSNotification?)?.rm_transaction else {
            return
        }

        Feature(rawValue: transaction.payment.productIdentifier)?.store()
    }
}

extension FeatureManager {
    
    enum Feature: String {
        case lowPriceSubscription = "lowPriceSubscription"
        case mediumPriceSubscription = "mediumPriceSubscription"
        case highPriceSubsription = "highPriceSubsription"
        
        var isPurchased: Bool {
            return UserDefaults.standard.bool(forKey: rawValue)
        }
        
        var price: String {
            return RMStore.localizedPrice(of: RMStore.default().product(forIdentifier: rawValue))
        }

        func purchase(completion: ((Bool) -> Void)? = nil) {
            FeatureManager.shared.purchase(self, with: completion)
        }
        
        fileprivate func store() {
            UserDefaults.standard.set(true, forKey: rawValue)
        }
    }
}

