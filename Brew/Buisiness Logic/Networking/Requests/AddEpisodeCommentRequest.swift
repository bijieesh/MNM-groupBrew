//
//  AddEpisodeCommentRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct AddEpisodeCommentRequest: RequestType {
    typealias ResponseObjectType = StatusResponse
    typealias ErrorType = SimpleError

    let path: String = "api/episode/comment"
    let method: HTTPMethod = .post
    let bodyParams: [String : Any]

    init(episodeId: Int, comment: String) {
        bodyParams = [
            "episode_id": episodeId,
            "comment": comment
        ]
    }
}
