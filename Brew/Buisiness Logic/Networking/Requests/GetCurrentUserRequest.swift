//
//  GetCurrentUserRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct GetCurrentUserRequest: RequestType {
    typealias ResponseObjectType = User
    typealias ErrorType = MessageError

    let path: String = "api/user/me"
    let method: HTTPMethod = .post

    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard let expectedJson = serverJson as? [String: Any], let userJson = expectedJson["data"] as? [String: Any], statusCode.isSuccessful else {
            return serverJson
        }

        return userJson
    }
}
