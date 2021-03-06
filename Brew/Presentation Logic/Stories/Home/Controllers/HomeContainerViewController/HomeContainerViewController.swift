//
//  HomeContainerViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/7/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class HomeContainerViewController: AppViewController {
	enum ContainerType {
		case newRelease, shows, saved
	}
	
	@IBOutlet private var homeButton: UIButton!
	@IBOutlet private var podcastsButton: UIButton!
	@IBOutlet private var downloadsButton: UIButton!
	
	@IBOutlet private var scrollView: UIScrollView!
	@IBOutlet private var stackView: UIStackView!
	
	var topButtons: [UIButton] {
		return [homeButton, podcastsButton, downloadsButton]
	}
	
	var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupView()
    }
}

//MARK: - @IBAction
private extension HomeContainerViewController {
	@IBAction func homePressed() {
		topButtons.forEach { $0.isSelected = false }
		homeButton.isSelected = true
		scrollTo(container: .newRelease)
	}
	
	@IBAction func podcastsPressed() {
		topButtons.forEach { $0.isSelected = false }
		podcastsButton.isSelected = true
		scrollTo(container: .shows)
	}
	
	@IBAction func downloadsPressed() {
		topButtons.forEach { $0.isSelected = false }
		downloadsButton.isSelected = true
		scrollTo(container: .saved)
	}
}

//MARK: Controller Helpers
private extension HomeContainerViewController {
	func setupView() {
		topButtons.first?.isSelected = true
		setupControllers()
	}
	
	func setupControllers() {
		controllers.forEach {
			let view = UIView()
			stackView.addArrangedSubview(view)
			view.add(controller: $0)
		}
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
