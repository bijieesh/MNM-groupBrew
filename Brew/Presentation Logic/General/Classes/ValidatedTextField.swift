//
//  ValidatedTextField.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class ValidatedTextField: UITextField {
    private struct Constants {
        static let emailRegex = "[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}"
        static let phoneRegex = "^((\\+)|(00))[0-9]{6,14}$"
    }

    @IBInspectable var minLength: Int = 0
    @IBInspectable var maxLength: Int = .max
    @IBInspectable var regex: String?
    
    @IBInspectable var invalidColor: UIColor = UIColor.red.withAlphaComponent(0.15)

    @IBInspectable var isRequired: Bool {
        set { minLength = max(minLength, 1) }
        get { return minLength > 0 }
    }

    @IBInspectable var mustBeEmail: Bool = false {
        didSet { regex = Constants.emailRegex }
    }

    @IBInspectable var mustBePhoneNumber: Bool = false {
        didSet { regex = Constants.phoneRegex }
    }

    @IBOutlet weak var equalTo: UITextField?

    var isValid: Bool {
        guard let text = text else {
            return false
        }

        if let regex = regex, !text.matches(regex) {
            return false
        }

        if let equalToText = equalTo?.text, text != equalToText {
            return false
        }

        if isRequired && text.replacingOccurrences(of: " ", with: "").isEmpty {
            return false
        }

        return text.count >= minLength && text.count <= maxLength
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addTarget(self, action: #selector(reset), for: .editingChanged)
    }

    @objc func reset() {
        updateUI(isValid: true)
    }

    @discardableResult func validate() -> Bool {
        let valid = isValid
        updateUI(isValid: valid)
        return valid

    }

    func markInvalid() {
        updateUI(isValid: false)
    }

    @discardableResult static func validateAll(in view: UIView) -> Bool {
        if let field = view as? ValidatedTextField  {
            return field.validate()
        }
        else {
            return view.subviews.reduce(true) { validateAll(in: $1) && $0 }
        }
    }

    private func updateUI(isValid: Bool) {
        backgroundColor = isValid ? .clear : invalidColor
    }
}

private extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

