//
//  TokenRefreshRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/23/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class TokenRefreshRequest: RequestType {
    typealias ResponseObjectType = AuthResponse
    typealias ErrorType = SimpleError

    let headers: [NetworkingHeader]
    let path: String = "refresh"
    let method: HTTPMethod = .post

    init(oldToken: AuthToken) {
        headers = [oldToken]
    }
}
