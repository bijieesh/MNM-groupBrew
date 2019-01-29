//
//  AppAuthManager.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/23/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class AppAuthManager: AuthManager {

    private struct Constants {
        static let tokenKey = "AppAuthManager.tokenKey"
    }

    var onTokenUpdated: ((AuthToken?) -> Void)?

    var onLoggedOut: (() -> Void)?

    var isUserLoggedIn: Bool {
        return authToken != nil
    }

    var authToken: AuthToken? {
        set {
            guard authToken != newValue else {
                return
            }

            UserDefaults.standard.set(newValue?.token, forKey: Constants.tokenKey)
            onTokenUpdated?(newValue)
        }

        get {
            return UserDefaults.standard.string(forKey: Constants.tokenKey).flatMap { .bearer(token: $0) }
        }
    }

    func handle(_ authResponse: AuthResponse) {
        authToken = .bearer(token: authResponse.token)
    }

    @discardableResult
    func refreshToken(completion: ((_ success: Bool) -> Void)?) -> Bool {
        guard let oldToken = authToken else {
            completion?(false)
            return false
        }

        TokenRefreshRequest(oldToken: oldToken).execute(
            retryOnFail: false,

            onSuccess: { [weak self] (response) in
                self?.authToken = .bearer(token: response.token)
                completion?(true)
        },

            onError: { [weak self] _ in
                self?.logout(completion: nil)
                completion?(false)
        })

        return true
    }

    @discardableResult
    func logout(completion: ((_ success: Bool) -> Void)?) -> Bool {
        deleteToken()
        authToken = nil
        onLoggedOut?()
        completion?(true)
        return true
    }

    private func storeToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.tokenKey)
    }
    
    private func deleteToken() {
        UserDefaults.standard.removeObject(forKey: Constants.tokenKey)
    }
}
