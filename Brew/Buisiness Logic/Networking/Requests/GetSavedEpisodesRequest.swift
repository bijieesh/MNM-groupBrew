//
//  GetSavedEpisodesRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct GetSavedEpisodesRequest: RequestType {
	typealias ResponseObjectType = [Episode]
	typealias ErrorType = SimpleError
	
	var path: String = "api/user/downloads"
	var method: HTTPMethod = .get
	
	func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
		guard let mappedJson = serverJson as? [String : Any], let downloads = mappedJson["downloads"] as? [[String : Any]] else {
			return serverJson
		}
		
		return downloads.compactMap { $0["episode"] as? [String : Any] }
	}
}
