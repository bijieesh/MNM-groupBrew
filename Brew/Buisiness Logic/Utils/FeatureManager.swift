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
    
    func fetchAvailability(with completion: ((_ available: [Feature], _ unavailable: [Feature]) -> Void)? = nil) {
        let featureIds = [
            Feature.smallPriceSubscription.rawValue,
            Feature.mediumPriceSubscription.rawValue,
            Feature.highPriceSubscription.rawValue
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
                                            
                                            completion?(available, unavailable)
        },
                                          failure: { _ in
                                            completion?([], [])
        })
    }
    
    func purchase(_ feature: Feature, fetchProductsOnFail: Bool = true, with callback: ((_ transactionId: String?) -> Void)? = nil) {
        RMStore.default().addPayment(feature.rawValue,
                                     success: {
                                        feature.store()
                                        let id = ($0?.original ?? $0)?.transactionIdentifier
                                        callback?(id)
        },
                                     failure: { (_, error) in
                                        if fetchProductsOnFail {
                                            self.fetchAvailability { (products, _) in
                                                if products.contains(where: { $0.rawValue == feature.rawValue }) {
                                                    self.purchase(feature, fetchProductsOnFail: false, with: callback)
                                                }
                                                else {
                                                    callback?(nil)
                                                }
                                            }
                                        }
                                        else {
                                            callback?(nil)
                                        }
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
        case smallPriceSubscription = "subscription.small"
        case mediumPriceSubscription = "subscription.medium"
        case highPriceSubscription = "subscription.high"
        
        var isPurchased: Bool {
            return UserDefaults.standard.bool(forKey: rawValue)
        }
        
        var price: String {
            return RMStore.localizedPrice(of: RMStore.default().product(forIdentifier: rawValue))
        }

        func purchase(completion: ((String?) -> Void)? = nil) {
            FeatureManager.shared.purchase(self, with: completion)
        }
        
        fileprivate func store() {
            UserDefaults.standard.set(true, forKey: rawValue)
        }
    }
}

