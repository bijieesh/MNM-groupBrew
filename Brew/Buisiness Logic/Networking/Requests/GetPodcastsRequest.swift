//
//  GetPodcastsRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class GetPodcastsRequest: RequestType {
    enum RequestType: String {
        case discover
        case popular
        case editors
		case all
		
		var name: String {
			switch self {
			case .discover: return "Discover"
			case .popular: return "Top podcasts"
			case .editors: return "Editros' choice"
			case .all: return "All"
			}
		}
    }

    typealias ResponseObjectType = [Podcast]
    typealias ErrorType = SimpleError

    let path: String
    let method: HTTPMethod = .get

    init(type: RequestType) {
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
        else if let podcastsJson = mappedJson["podcast"] as? [[String: Any]] {
            data = podcastsJson
        }
        
        return data
    }
}
