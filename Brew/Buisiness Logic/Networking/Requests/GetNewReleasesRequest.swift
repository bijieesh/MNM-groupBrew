//
//  GetNewReleasesRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/9/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct GetNewReleasesRequest: RequestType {
    typealias ResponseObjectType = [Episode]
    typealias ErrorType = SimpleError

    let path: String = "api/episodes/new"
    let method: HTTPMethod = .get

    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard
            let mappedJson = serverJson as? [String: Any],
            let episodesJson = mappedJson["episodes"] as? [String: Any],
            let dataJson = episodesJson["data"] as? [[String: Any]],
            statusCode.isSuccessful else {
                return serverJson
        }

        return dataJson
    }
}
