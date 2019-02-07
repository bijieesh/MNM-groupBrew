//
//  UIView + Controller.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/7/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

extension UIView {
	var parentViewController: UIViewController? {
		if let nextResponder = self.next as? UIViewController {
			return nextResponder
		} else if let nextResponder = self.next as? UIView {
			return nextResponder.parentViewController
		} else {
			return nil
		}
	}
	
	func add(controller: UIViewController) {
		parentViewController?.addChild(controller)
		self.addSubview(controller.view)
		controller.didMove(toParent: parentViewController)
		controller.view.stretch(in: self)
	}
	
	func remove(controller: UIViewController) {
		controller.willMove(toParent: nil)
		controller.removeFromParent()
		controller.view.removeFromSuperview()
	}
	
	func stretch(in view: UIView) {
		self.translatesAutoresizingMaskIntoConstraints = false
		
		self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}
