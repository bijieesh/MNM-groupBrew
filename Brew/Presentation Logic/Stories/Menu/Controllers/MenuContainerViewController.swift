//
//  ContainerViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class MenuContainerViewController: AppViewController {
	
	var onControllerSelected: ((Int) -> Void)?
	
	private let controllers: [UIViewController]
	
	private var selectedController: UIViewController {
		return controllers[selectedIndex]
	}
	
	var selectedIndex: Int = 0 {
		didSet {
			tabBar?.selectedItem = tabBar.items?[selectedIndex]
			updateContentController()
		}
	}
	
	var showPlayerView: Bool = false {
		didSet {
			showPlayer()
		}
	}
	
	//MARK: IBOutlets
	@IBOutlet private var controllersContainer: UIView!
	@IBOutlet var playerContainer: UIView!
	@IBOutlet private var tabBar: UITabBar!
	@IBOutlet private var heightForPlayerContainer: NSLayoutConstraint!
	
	//MARK: Public properties
	
	init(controllers: [UIViewController]) {
		self.controllers = controllers
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		showPlayerView = false
		setupTabBar()
		updateContentController()
	}
	
	private func showPlayer() {
		if showPlayerView {
			heightForPlayerContainer.constant = 70
		} else {
			heightForPlayerContainer.constant = 0
		}
	}
	
	private func updateContentController() {
		let controller = controllers[selectedIndex]
		
		selectedController.view.removeFromSuperview()
		controller.willMove(toParent: self)
		controller.view.translatesAutoresizingMaskIntoConstraints = false
		controllersContainer.addSubview(controller.view)
		addChild(controller)
		
		controller.view.widthAnchor.constraint(equalTo: controllersContainer.widthAnchor).isActive = true
		controller.view.heightAnchor.constraint(equalTo: controllersContainer.heightAnchor).isActive = true
		controller.view.centerXAnchor.constraint(equalTo: controllersContainer.centerXAnchor).isActive = true
		controller.view.centerYAnchor.constraint(equalTo: controllersContainer.centerYAnchor).isActive = true
		
		controller.didMove(toParent: self)
	}
	
	private func setupTabBar() {
		tabBar.tintColor = .appOrange
		tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		tabBar.items = controllers.map { $0.tabBarItem }
		selectedIndex = 0
	}
}

//MARK: UITabBarDelegate
extension MenuContainerViewController: UITabBarDelegate {
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		guard let index = tabBar.items?.firstIndex(of: item) else {
			return
		}
		
		selectedIndex = index
		onControllerSelected?(index)
	}
}
