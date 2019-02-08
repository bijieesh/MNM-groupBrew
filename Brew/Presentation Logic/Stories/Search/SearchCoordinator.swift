//
//  SearchCoordinator.swift
//  Brew
//
//  Created by Admin on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class SearchCoordinator: NavigationCoordinator {
	
	override func start() {
		super.start()
		setupSearchController()
	}
	
	private func setupSearchController() {
		let searchController = SearchViewController()
		let contentController = UINavigationController(rootViewController: searchController)
		contentController.isNavigationBarHidden = true
		
		navigationController?.pushViewController(searchController, animated: false)
	}
}
