//
//  PodcastSearchRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/13/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct PodcastSearchRequest: RequestType {
	typealias ResponseObjectType = [Podcast]
	typealias ErrorType = SimpleError
	
	let path: String
	let method: HTTPMethod = .get
	var queryParams: [(String, String)]
	
	init(searchText: String) {
		self.path = "api/search/podcasts"
		self.queryParams = [("q", searchText)]
	}
	
	func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
		guard let expectedJson = serverJson as? [String: Any], let podcastJson = expectedJson["podcast"] as? [Any], statusCode.isSuccessful else {
			return serverJson
		}
		
		return podcastJson
	}
}
