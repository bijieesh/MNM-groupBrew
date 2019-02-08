//
//  SearchCoordinator.swift
//  Brew
//
//  Created by Yriy Malyts on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class SearchCoordinator: NavigationCoordinator {
	
	private let imagePickerCoordinator = ImagePickerCoordinator()
	
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
