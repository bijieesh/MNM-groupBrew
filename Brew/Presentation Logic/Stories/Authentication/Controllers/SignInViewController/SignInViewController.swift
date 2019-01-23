//
//  SignInViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class SignInViewController: AppViewController {
    var onSignUpSelected: (() -> Void)?
    var onSignIn: ((SignInViewController, String, String) -> Void)?

    @IBOutlet private var emailTextField: ValidatedTextField!
    @IBOutlet private var passwordTextField: ValidatedTextField!

    @IBAction private func signInPressed() {
        guard ValidatedTextField.validateAll(in: view) else {
            return
        }

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        onSignIn?(self, email, password)
    }

    @IBAction private func signUpPressed() {
        onSignUpSelected?()
    }

    func markInvalid() {
        emailTextField.markInvalid()
        passwordTextField.markInvalid()
    }
}
