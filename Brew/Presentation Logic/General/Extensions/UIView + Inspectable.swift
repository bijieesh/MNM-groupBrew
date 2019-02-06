//
//  UIView + Inspectable.swift
//  
//
//  Created by Admin on 9/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor.init(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowBlur: CGFloat {
        get { return layer.shadowRadius * 2.0 }
        set { layer.shadowRadius = newValue / 2.0 }
    }
    
    @IBInspectable
    var shadowAlpha: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowXY: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
	
	@IBInspectable
	var spread: CGFloat {
		get { return 0}
		set {
			let dx = -newValue
			let rect = bounds.insetBy(dx: dx, dy: dx)
			layer.shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
}
