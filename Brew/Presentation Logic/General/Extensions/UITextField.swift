//
//  UITextField.swift
//  Brew
//
//  Created on 2/6/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

extension UITextField{
	@IBInspectable var placeHolderColor: UIColor? {
		get {
			return self.placeHolderColor
		}
		set {
			self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
		}
	}
}
