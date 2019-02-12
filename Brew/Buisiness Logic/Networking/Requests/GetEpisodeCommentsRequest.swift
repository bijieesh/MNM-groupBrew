//
//  GetEpisodeCommentsRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct GetEpisodeCommentsRequest: RequestType {
    typealias ResponseObjectType = [Comment]
    typealias ErrorType = SimpleError

    let path: String
    let method: HTTPMethod = .get

    init(episodeId: Int) {
        path = "api/episode/comments/\(episodeId)"
    }

    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard let mappedJson = serverJson as? [String: Any], let commentsJson = mappedJson["comments"] as? [Any], statusCode.isSuccessful else {
            return []
        }

        return commentsJson
    }
}
