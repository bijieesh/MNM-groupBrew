//
//  UIControl + Action.swift
//  SetaiTV
//
//  Created by Vasyl Khmil on 12/3/18.
//  Copyright © 2018 Vasyl Khmil. All rights reserved.
//

import UIKit

class BaseButton: UIControl {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		loadFromNib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		loadFromNib()
	}
	
	private func loadFromNib() {
		guard let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last,
			let view = Bundle.main.loadNibNamed(className, owner: self)?.first as? UIView else {
				return }
		
		self.addSubview(view)
		addConstraints(to: view)
		view.isUserInteractionEnabled = false
		self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	}
	
	private func addConstraints(to view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}
	
	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.2) {
				self.subviews.forEach {
					$0.alpha = self.isHighlighted ? 0.4 : 1
				}
			}
		}
	}
}
