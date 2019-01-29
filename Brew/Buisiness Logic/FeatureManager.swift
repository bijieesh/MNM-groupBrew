//
//  FeatureManager.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/29/18.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation
import RMStore
import SwiftKeychainWrapper

class FeatureManager: NSObject, RMStoreObserver {
    static let shared = SubscriptionManager()
    
    func prepare() {
        RMStore.default().add(self)
        RMStore.default().restoreTransactions()
    }
    
    func restore(with callback: ((_ restored: Bool) -> Void)? = nil) {
        RMStore.default().restoreTransactions(
            onSuccess: { _ in
                callback?(true)
        }, failure: { _ in
            callback?(false)
        })
    }
    
    func fetchAvailability(with callabck: ((_ available: [Feature], _ unavailable: [Feature]) -> Void)? = nil) {
        let featuresId = Set([
            Feature.lowPriceSubscription,
            Feature.mediumPriceSubscription,
            Feature.highPriceSubsription
                ].map({ $0.rawValue }))
        
        RMStore.default().requestProducts(featuresId,
                                          success: { (products, invalidProductIds) in
                                            
                                            var available: [Feature] = []
                                            var unavailable: [Feature] = []
                                            
                                            if let skProducts = products as? [SKProduct] {
                                                available = skProducts.compactMap({ Feature(rawValue: $0.productIdentifier) })
                                            }
                                            
                                            if let unavailableStrings = invalidProductIds as? [String] {
                                                unavailable = unavailableStrings.compactMap({ Feature(rawValue: $0) })
                                            }
                                            
                                            callabck?(available, unavailable)
        },
                                          failure: { _ in })
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
    
    // MARK: RMStoreObserver
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

        private static let keychain = KeychainWrapper(serviceName: "AppFeature")
        
        var isPurchased: Bool {
            return type(of: self).keychain.bool(forKey: rawValue) ?? false
        }
        
        var price: String {
            return RMStore.localizedPrice(of: RMStore.default().product(forIdentifier: rawValue))
        }
        
        func store() {
            type(of: self).keychain.set(true, forKey: rawValue)
        }
    }
}

