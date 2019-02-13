//
//  SaveEpisodeRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SaveEpisodeRequest: RequestType {
	typealias ResponseObjectType = StatusResponse
	typealias ErrorType = SimpleError
	
	var path: String = "api/episode/downloads"
	var method: HTTPMethod = .post
	var bodyParams: [String : Any]
	
	init(id: Int) {
		self.bodyParams = ["episode_id" : id]
	}
}
