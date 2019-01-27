//
//  SignUpRequest.swift
//  Brew
//
//  Created by new user on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SignUpRequest: RequestType {
    typealias ResponseObjectType = AuthResponse
    typealias ErrorType = SimpleError

    let path = "api/register"
    let method: HTTPMethod = .post
    let bodyParams: [String: Any]

    init(name: String, country: String, email: String, password: String, mobile: String?) {
        var bodyParams = [
            "name": name,
            "email": email,
            "password": password,
            "country": country
        ]

        if let mobile = mobile {
            bodyParams["mobile"] = mobile
        }

        self.bodyParams = bodyParams
    }
}
