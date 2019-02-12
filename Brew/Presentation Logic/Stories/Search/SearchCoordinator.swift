//
//  SearchCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class SearchCoordinator: NavigationCoordinator {
	
	override func start() {
		super.start()
		
		setupSearchController()
	}
}

//MARK: - View Helpers
private extension SearchCoordinator {
	func setupSearchController() {
		let searchController = SearchViewController()
		loadCategories(for: searchController)
		
		searchController.onCategory = { [weak self] in
			self?.show($0)
		}
		
		searchController.onTopPodcast = { [weak self] in
			self?.showPodcasts(for: .popular)
		}
		searchController.onEditorsChoice = { [weak self] in
			self?.showPodcasts(for: .editors)
		}
		
		let contentController = UINavigationController(rootViewController: searchController)
		contentController.isNavigationBarHidden = true
		
		navigationController?.pushViewController(searchController, animated: false)
	}
	
	func showPodcasts(for type: GetPodcastsRequest.RequestType) {
		let request = GetPodcastsRequest(type: type)
		loadPodcatListCoordinator(with: request,  title: type.name)
	}
	
	func show(_ category: Category) {
		let request = GetPodcastsRequest(categoryId: category.id)
		loadPodcatListCoordinator(with: request, title: category.name)
	}
	
	func loadPodcatListCoordinator<T: RequestType>(with request: T, title: String) where T.ResponseObjectType == [Podcast], T.ErrorType == SimpleError {
		let coordinator = PodcastsListCoordinator(request: request, title: title)
		coordinator.start()
		
		navigationController?.pushViewController(coordinator.contentController, animated: true)
	}
}

//MARK: - Server Communication
private extension SearchCoordinator {
	func loadCategories(for controller: SearchViewController) {
		GetAllCategoriesRequest().execute(onSuccess: { categories in
			controller.data = categories
		})
	}
}

