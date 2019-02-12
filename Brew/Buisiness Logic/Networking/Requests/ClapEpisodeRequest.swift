//
//  ClapEpisodeRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct ClapEpisodeRequest: RequestType {
    typealias ResponseObjectType = StatusResponse
    typealias ErrorType = SimpleError

    let path: String = "api/episode/clap"
    let method: HTTPMethod = .post
    var bodyParams: [String : Any]

    init(episodeId: Int) {
        bodyParams = [
            "episode_id": episodeId
        ]
    }
}
