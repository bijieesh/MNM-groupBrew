//
//  UpdateActivityRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/10/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class UpdateActivityRequest: RequestType {
    typealias ResponseObjectType = Bool
    typealias ErrorType = SimpleError

    let path: String = "api/episode/activity"
    let method: HTTPMethod = .post

    let bodyParams: [String : Any]

    init(episodeId: Int, duration: Int) {
        bodyParams = [
            "episode_id" : episodeId,
            "duration" : duration
        ]
    }

    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        if let mappedJson = serverJson as? [String : Any] {
            return mappedJson["success"] ?? serverJson
        }
        else {
            return serverJson
        }
    }
}
