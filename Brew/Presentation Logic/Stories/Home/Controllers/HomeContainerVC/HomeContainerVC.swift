//
//  HomeContainerVC.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/7/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class HomeContainerVC: AppViewController {
	enum ContainerType {
		case newRelease, shows, saved
	}
	
	@IBOutlet private var scrollView: UIScrollView!
	
	@IBOutlet private var newReleasesButton: UIButton!
	@IBOutlet private var showsButton: UIButton!
	@IBOutlet private var savedButotn: UIButton!
	
	@IBOutlet private var newReleaseCOntainerView: UIView!
	@IBOutlet private var showsContainerView: UIView!
	@IBOutlet private var savedContainerView: UIView!
	
	var topButtons: [UIButton] {
		return [newReleasesButton, showsButton, savedButotn]
	}
	
	var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupView()
    }
}

private extension HomeContainerVC {
	@IBAction func newReleasePressed() {
		topButtons.forEach { $0.isSelected = false }
		newReleasesButton.isSelected = true
		scrollTo(container: .newRelease)
	}
	
	@IBAction func showsPressed() {
		topButtons.forEach { $0.isSelected = false }
		showsButton.isSelected = true
		scrollTo(container: .shows)
	}
	
	@IBAction func savedPressed() {
		topButtons.forEach { $0.isSelected = false }
		savedButotn.isSelected = true
		scrollTo(container: .saved)
	}
}

private extension HomeContainerVC {
	func setupView() {
		topButtons.first?.isSelected = true
	}
	
	func scrollTo(container: ContainerType) {
		var point = CGPoint(x: 0, y: 0)
		let width = scrollView.contentSize.width / CGFloat(topButtons.count)
		
		switch container {
		case .newRelease:
			point.x = 0
		case .shows:
			point.x = width * 1
		case .saved:
			point.x = width * 2
		}
		
		scrollView.setContentOffset(point, animated: true)
	}
}
