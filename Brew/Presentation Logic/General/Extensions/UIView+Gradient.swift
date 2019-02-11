//
//  UIView + Gradient.swift
//  
//
//  Created by Vasyl Khmil on 1/8/19.
//  Copyright © 2019 Vasyl Khmil. All rights reserved.
//

import UIKit

extension UIView {
	
	func applyGradient(_ colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> Void {
		let gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.cornerRadius = self.cornerRadius
		gradient.colors = colors.map { $0.cgColor }
		gradient.startPoint = startPoint
		gradient.endPoint = endPoint
		self.layer.addSublayer(gradient)
	}
}

