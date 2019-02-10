//
//  SearchCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class SearchCoordinator: NavigationCoordinator {
	
	override func start() {
		super.start()
		loadCategory()
	}
	
	private func loadCategory() {
		GetAllCategoriesRequest().execute(
			onSuccess: { [weak self] in
				self?.setupSearchController(with: $0)
			},
			
			onError: { error in
				error.display()
		})
	}
	
	private func setupSearchController(with categories: [Category]) {
		let searchController = SearchViewController()
		searchController.data = categories
		
		searchController.onCategorySelected = { [weak self] in
			self?.show($0)
		}
		
		let contentController = UINavigationController(rootViewController: searchController)
		contentController.isNavigationBarHidden = true
		
		navigationController?.pushViewController(searchController, animated: false)
	}

    private func show(_ category: Category) {
        let request = GetPodcastsRequest(categoryId: category.id)
        let coordinator = PodcastsListCoordinator(request: request)
        coordinator.start()
        navigationController?.pushViewController(coordinator.contentController, animated: true)
    }
}

