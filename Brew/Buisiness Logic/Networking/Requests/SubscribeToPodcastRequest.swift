//
//  SubscribeToPodcastRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SubscribeToPodcastRequest: RequestType {
    typealias ResponseObjectType = StatusResponse
    typealias ErrorType = SimpleError

    let path: String = "api/user/podcast/follow"
    let method: HTTPMethod = .post
    let bodyParams: [String : Any]

    init(podcastId: Int) {
        bodyParams = [
            "podcast_id": podcastId
        ]
    }
}
