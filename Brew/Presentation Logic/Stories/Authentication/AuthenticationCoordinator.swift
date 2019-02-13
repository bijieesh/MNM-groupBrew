//
//  AuthenticationCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class AuthenticationCoordinator: NavigationCoordinator {

    var onLogin: (() -> Void)?
    var onSignUp: (() -> Void)?

    private let authManager: AppAuthManager

    init(authManager: AppAuthManager) {
        self.authManager = authManager
        super.init()
    }

    override func start() {
        super.start()
        showSignIn()
    }

    private func showSignIn() {
        let controller = SignInViewController()

        controller.onSignUpSelected = { [weak self] in
            self?.showSignUp()
        }

        controller.onSignIn = { [weak self] (controller, email, password) in
            self?.signIn(with: email, password, controller: controller)
        }

        navigationController?.pushViewController(controller, animated: false)
    }

    private func showSignUp() {
        let controller = SignUpViewController()

        controller.onSignInSelected =  { [weak self] in
            self?.showSignIn()
        }

        controller.onSignUp = { [weak self] (name, email, password, mobile) in
            self?.signUp(with: name, email, password, mobile)
        }

        navigationController?.pushViewController(controller, animated: false)
    }

    private func signIn(with email: String, _ password: String, controller: SignInViewController) {
        let request = LoginRequest(email: email, password: password)
        request.execute(
            onSuccess: { [weak self] response in
                self?.authenticate(with: response, completion: self?.onLogin)
            },
            onError: { error in
                if case let .custom(_, statusCode) = error, statusCode.isUnauthorize {
                    controller.markInvalid()
                }
                else {
                    error.display()
                }
        })
    }

    private func signUp(with name: String, _ email: String, _ password: String, _ mobile: String? = nil) {
        let request = SignUpRequest(name: name, email: email, password: password, mobile: mobile)
        request.execute(
            onSuccess: { [weak self] response in
                self?.authenticate(with: response, completion: self?.onSignUp)
            },
            onError: { error in
                error.display()
        })
    }

    private func authenticate(with response: AuthResponse, completion: (() -> Void)?) {
        authManager.handle(response)
        completion?()
        end()
    }
}
