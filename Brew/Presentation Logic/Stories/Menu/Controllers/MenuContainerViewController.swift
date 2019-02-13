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
		willSet {
			removeContentController()
		}
		
		didSet {
			tabBar?.selectedItem = tabBar.items?[selectedIndex]
			addContentController()
		}
	}
	
	//MARK: IBOutlets
	@IBOutlet private var controllersContainer: UIView!
	@IBOutlet private var playerContainer: UIView!
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
		setupTabBar()
		addContentController()
	}
	
    func addPlayer(_ miniPlayer: UIViewController) {
        miniPlayer.willMove(toParent: self)
        playerContainer.addSubview(miniPlayer.view)
        addChild(miniPlayer)
        miniPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.view.leadingAnchor.constraint(equalTo: playerContainer.leadingAnchor).isActive = true
        miniPlayer.view.topAnchor.constraint(equalTo: playerContainer.topAnchor).isActive = true
        miniPlayer.view.trailingAnchor.constraint(equalTo: playerContainer.trailingAnchor).isActive = true
        miniPlayer.view.bottomAnchor.constraint(equalTo: playerContainer.bottomAnchor).isActive = true
        miniPlayer.didMove(toParent: self)
    }
	
	private func addContentController() {
		selectedController.willMove(toParent: self)
		selectedController.view.translatesAutoresizingMaskIntoConstraints = false
		controllersContainer.addSubview(selectedController.view)
		addChild(selectedController)
		
		selectedController.view.widthAnchor.constraint(equalTo: controllersContainer.widthAnchor).isActive = true
		selectedController.view.heightAnchor.constraint(equalTo: controllersContainer.heightAnchor).isActive = true
		selectedController.view.centerXAnchor.constraint(equalTo: controllersContainer.centerXAnchor).isActive = true
		selectedController.view.centerYAnchor.constraint(equalTo: controllersContainer.centerYAnchor).isActive = true
		
		selectedController.didMove(toParent: self)
	}
	
	private func removeContentController() {
		selectedController.willMove(toParent: nil)
		selectedController.view.removeFromSuperview()
		selectedController.removeFromParent()
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
