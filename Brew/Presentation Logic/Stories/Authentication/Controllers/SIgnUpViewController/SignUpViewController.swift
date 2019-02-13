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
    var onSignUp: ((String, String, String, String?) -> Void)?

	@IBOutlet weak var backgraundGradientView: UIView!
	@IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var mobileTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var confirmPasswordTextField: UITextField!
	
	let colors = [#colorLiteral(red: 0.2778550386, green: 0.2935783863, blue: 0.3268206716, alpha: 1), #colorLiteral(red: 0.1567189991, green: 0.1561391652, blue: 0.1934350431, alpha: 1)]
	let startPoint = CGPoint(x:0.0, y:0.0)
	let endPoint = CGPoint(x:1.0, y:1.0)
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		backgraundGradientView.applyGradient(colors, startPoint: startPoint, endPoint: endPoint)
	}

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
        let mobile = mobileTextField.text

        onSignUp?(name, email, password, mobile)
    }
}
