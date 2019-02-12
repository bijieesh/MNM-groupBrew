//
//  GetPodcastsRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class GetPodcastsRequest: RequestType {

    enum `Type`: String {
        case discover
        case popular
        case editors
		case all
    }

    typealias ResponseObjectType = [Podcast]
    typealias ErrorType = SimpleError

    let path: String
    let method: HTTPMethod = .get

    init(type: Type) {
        path = "api/podcast/\(type)"
    }

    init(categoryId: Int) {
        path = "api/podcast/category/\(categoryId)"
    }

    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard
            let mappedJson = serverJson as? [String: Any],
            statusCode.isSuccessful else {
            return serverJson
        }
		
		//TODO: Delete this code when server fix data structure
        var data = mappedJson["data"] as? [[String: Any]] ?? []
		
		if let podcastJson = mappedJson["podcast"] as? [String : Any] {
            data = podcastJson["data"] as? [[String: Any]] ?? []
		}
        
        return data
    }
}
