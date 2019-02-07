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

	@IBOutlet private var backgraundGradientView: UIView!
    @IBOutlet private var emailTextField: ValidatedTextField!
    @IBOutlet private var passwordTextField: ValidatedTextField!
	
	let colors = [#colorLiteral(red: 0.2778550386, green: 0.2935783863, blue: 0.3268206716, alpha: 1), #colorLiteral(red: 0.1567189991, green: 0.1561391652, blue: 0.1934350431, alpha: 1)]
	let startPoint = CGPoint(x:0.0, y:0.0)
	let endPoint = CGPoint(x:1.0, y:1.0)

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		backgraundGradientView.applyGradient(colors, startPoint: startPoint, endPoint: endPoint)
	}

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
