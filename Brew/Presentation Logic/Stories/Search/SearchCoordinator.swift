//
//  SearchCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

final class SearchCoordinator: NavigationCoordinator {
	typealias PodcastAction = (Podcast, Int) -> Void
	
	var onPodcast: PodcastAction?
	
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
		
		searchController.onSearch = { [weak self] searchText in
			self?.showSearchPodcast(for: searchText)
		}
		
		let contentController = UINavigationController(rootViewController: searchController)
		contentController.isNavigationBarHidden = true
		
		navigationController?.pushViewController(searchController, animated: false)
	}
	
	func showSearchPodcast(for searchText: String) {
		let request = PodcastSearchRequest(searchText: searchText)
		loadPodcatListCoordinator(with: request, title: searchText)
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
		
		coordinator.onPodcast = { [weak self] in
			self?.onPodcast?($0, $1)
		}
		
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

