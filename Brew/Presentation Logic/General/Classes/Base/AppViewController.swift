//
//  AppViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
	typealias Action = () -> Void
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    var onClose: Action?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }
}
