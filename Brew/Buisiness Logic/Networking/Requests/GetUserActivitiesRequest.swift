//
//  GetUserActivitiesRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/11/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct GetUserActivitiesRequest: RequestType {
	typealias ResponseObjectType = [Activity]
	typealias ErrorType = SimpleError
	
	var path: String = "api/user/activity"
	var method: HTTPMethod = .get
	
	func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
		guard
			let mappedJson = serverJson as? [String : Any],
			let activityJson = mappedJson["activity"] as? [[String : Any]],
			statusCode.isSuccessful else {
				return serverJson
		}
		
		return activityJson
	}
}
