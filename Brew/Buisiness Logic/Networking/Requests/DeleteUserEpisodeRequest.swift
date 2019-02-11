//
//  DeleteUserEpisodeRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/11/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct DeleteUserEpisodeResponse: Codable {
	let success: Bool
}

struct DeleteUserEpisodeRequest: RequestType {
	typealias ResponseObjectType = DeleteUserEpisodeResponse
	typealias ErrorType = SimpleError

	var path: String
	var method: HTTPMethod = .delete
	
	init(id: Int) {
		self.path = "api/episode/downloads/\(id)"
	}
}
