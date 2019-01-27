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
    
    var onUpdateProfile: ((SettingsViewController, String, String, String?, String) -> Void)?
    
    @IBOutlet private weak var changePasswordButton: UIButton!
    
    @IBOutlet private weak var updateInfoButton: UIButton!
    
    @IBOutlet private weak var nameTextField: ValidatedTextField!
    @IBOutlet private weak var emailTextField: ValidatedTextField!
    @IBOutlet private weak var mobileTextField: UITextField!
    @IBOutlet private weak var countryTextField: ValidatedTextField!
    @IBOutlet private weak var oldPasswordTextField: ValidatedTextField!
    @IBOutlet private weak var passwordTextField: ValidatedTextField!
    @IBOutlet private weak var confirmPasswordTextField: ValidatedTextField!
    
    @IBOutlet private weak var passwordStackView: UIStackView!
    
    @IBOutlet weak var userInfoStackView: UIStackView!
    
    var user: User?

    private var showUpdateButton: Bool = false {
        didSet {
            updateInfoButton.isHidden = !showUpdateButton
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = self.user {
            fillUserInfo(user)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        let profile = user.profile
        nameTextField?.text = profile.profile_first_name
        emailTextField?.text = user.email
        mobileTextField?.text = user.phone_number
        countryTextField?.text = user.country
    }
    
    func profileUpdated() {
        showUpdateButton = false
    }
    
    func updateProfile() {
        guard ValidatedTextField.validateAll(in: userInfoStackView) else {
            return
        }
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let country = countryTextField.text ?? ""
        let mobile = mobileTextField.text
        
        onUpdateProfile?(self, name, email, mobile, country)
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
    
    @IBAction private func updateTapped() {
        updateProfile()
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case nameTextField, emailTextField, countryTextField, mobileTextField:
            showUpdateButton = true
        default:
            break
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case passwordTextField, oldPasswordTextField, confirmPasswordTextField:
            guard ValidatedTextField.validateAll(in: passwordStackView) else {
                return
            }
            changePasswordButton.isHidden = false
        default:
            break
        }
    }
}
