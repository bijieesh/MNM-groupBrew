//
//  SettingsViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/26/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class SettingsViewController: AppViewController {
    
    typealias OnButtonTapped = ((_ on: SettingsViewController)->Void)
    
    //MARK: Variables
    
    var onBackTapped:OnButtonTapped?
    var onChangePassword: ((SettingsViewController, String, String) -> Void)?
    
    @IBOutlet private weak var changePasswordButton: UIButton!
    
    @IBOutlet private weak var nameTextField: ValidatedTextField!
    @IBOutlet private weak var emailTextField: ValidatedTextField!
    @IBOutlet private weak var mobileTextField: UITextField!
    @IBOutlet private weak var countryTextField: ValidatedTextField!
    @IBOutlet private weak var oldPasswordTextField: ValidatedTextField!
    @IBOutlet private weak var passwordTextField: ValidatedTextField!
    @IBOutlet private weak var confirmPasswordTextField: ValidatedTextField!
    
    @IBOutlet private weak var passwordStackView: UIStackView!
    
    var user: User?

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = self.user {
            fillUserInfo(user)
        }
    }
    
    func markInvalid() {
        passwordTextField.markInvalid()
        oldPasswordTextField.markInvalid()
        confirmPasswordTextField.markInvalid()
    }
    
    func clearPasswordFields() {
        passwordTextField.text = nil
        oldPasswordTextField.text = nil
        confirmPasswordTextField.text = nil
    }
    
    func fillUserInfo(_ user: User) {
        nameTextField?.text = user.name
        emailTextField?.text = user.email
        mobileTextField?.text = user.phone_number
        countryTextField?.text = user.country
    }
    
    //MARK: IBActions

    @IBAction private func backTapped() {
        onBackTapped?(self)
    }
    
    @IBAction private func changePasswordTapped() {
        let password = passwordTextField.text ?? ""
        let oldPassword = oldPasswordTextField.text ?? ""
        onChangePassword?(self, oldPassword, password)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard ValidatedTextField.validateAll(in: passwordStackView) else {
            return
        }
        changePasswordButton.isHidden = false
    }
}
