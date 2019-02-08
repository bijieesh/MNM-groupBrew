//
//  SaveEpisodeRequest.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SaveEpisodeResponse: Codable {
	let success: Bool
}

struct SaveEpisodeRequest: RequestType {
	typealias ResponseObjectType = SaveEpisodeResponse
	typealias ErrorType = SimpleError
	
	var path: String = "api/episode/downloads"
	var method: HTTPMethod = .post
	var bodyParams: [String : Any]
	
	init(id: Int) {
		self.bodyParams = ["episode_id" : id]
	}
}
