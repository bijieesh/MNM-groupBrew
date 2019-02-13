//
//  SaveLikedPodcastsRequest.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/13/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SaveLikedPodcastsRequest: RequestType {
	typealias ResponseObjectType = StatusResponse
	typealias ErrorType = SimpleError
	
	let path: String = "api/user/add/shows"
	let method: HTTPMethod = .post
	let bodyParams: [String : Any]
	
	init(idArray: [Int]) {
		bodyParams = ["podcasts" : idArray]
	}
}
