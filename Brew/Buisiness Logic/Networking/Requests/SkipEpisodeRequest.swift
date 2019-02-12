//
//  SkipEpisodeRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SkipEpisodeResponse: Codable {
	var success: Bool
}

struct SkipEpisodeRequest: RequestType {
	typealias ResponseObjectType = SkipEpisodeResponse
	typealias ErrorType = SimpleError
	
	var path: String = "api/episode/skip"
	var method: HTTPMethod = .post
	var bodyParams: [String : Any]
	
	init(id: Int) {
		self.bodyParams = ["episode_id" : id]
	}
}
