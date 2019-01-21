//
//  SignUpViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class SignUpViewController: AppViewController {
    var onSignInSelected: (() -> Void)?
    var onSignUp: ((String, String, String, String, String?) -> Void)?

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var mobileTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var confirmPasswordTextField: UITextField!

    @IBAction private func signInPressed() {
        onSignInSelected?()
    }

    @IBAction private func signUpPressed() {
        guard ValidatedTextField.validateAll(in: view) else {
            return
        }

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let country = countryTextField.text ?? ""
        let mobile = mobileTextField.text

        onSignUp?(name, country, email, password, mobile)
    }
}
