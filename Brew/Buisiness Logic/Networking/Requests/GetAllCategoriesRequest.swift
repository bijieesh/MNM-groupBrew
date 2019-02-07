//
//  GetAllCategoriesRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct GetAllCategoriesRequest: RequestType {
	typealias ResponseObjectType = [Category]
	typealias ErrorType = SimpleError
	
	let path: String = "api/categories/all"
	let method: HTTPMethod = .get
	
	func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard let expectedJson = serverJson as? [String: Any], let categoriesJson = expectedJson["categories"] as? [Any], statusCode.isSuccessful else {
			return serverJson
		}
		
		return categoriesJson
    }
}
