//
//  GetPodcastsRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct PodcastsResponse {
    
}

class GetPodcastsRequest: RequestType {

    enum `Type`: String {
        case discover
        case popular
        case new
        case editors
    }

    typealias ResponseObjectType = [Podcast]
    typealias ErrorType = SimpleError

    let path: String
    let method: HTTPMethod = .get

    init(type: Type) {
        path = "podcast/\(type)"
    }

    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard
            let expectedJson = serverJson as? [String: Any],
            let podcastsJson = expectedJson["podcast"] as? [String: Any],
            let dataJson = podcastsJson["data"] as? [Any],
            statusCode.isSuccessful else {
            return serverJson
        }

        return dataJson
    }
}
