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
    var onSignIn: ((String, String) -> Void)?

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    @IBAction private func signInPressed() {
        onSignIn?(emailTextField.text!, passwordTextField.text!)
    }

    @IBAction private func signUpPressed() {
        onSignUpSelected?()
    }
}
