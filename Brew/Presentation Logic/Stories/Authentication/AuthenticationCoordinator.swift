//
//  AuthenticationCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class AuthenticationCoordinator {
    var onSuccess: ((User) -> Void)?

    private let rootController: UIViewController

    init(rootController: UIViewController) {
        self.rootController = rootController
    }

    func start() {
        showSignIn()
    }

    private func showSignIn() {
        let controller = SignInViewController()

        controller.onSignUpSelected = showSignUp
        controller.onSignIn = signIn(with:_:)

        rootController.topController.present(controller, animated: false)
    }

    private func showSignUp() {
        let controller = SignUpViewController()

        controller.onSignInSelected = showSignIn
        controller.onSignUp = signUp(with:_:_:_:_:)

        rootController.topController.present(controller, animated: false)
    }

    private func signIn(with email: String, _ password: String) {
        let request = LoginRequest(email: email, password: password)
        authenticate(with: request)
    }

    private func signUp(with name: String, _ country: String, _ email: String, _ password: String, _ mobile: String? = nil) {
        let request = SignUpRequest(name: name, country: country, email: email, password: password, mobile: mobile)
        authenticate(with: request)
    }

    private func authenticate<T: RequestType>(with request: T) where T.ResponseObjectType == AuthResponse, T.ErrorType == SimpleError {
        request.execute(
            onSuccess: { [weak self] response in
                self?.onSuccess?(response.user)
        },
            onError: { error in
                error.show()
        })
    }
}
