//
//  LoginRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct LoginRequest: RequestType {
    typealias ResponseObjectType = AuthResponse
    typealias ErrorType = SimpleError

    let path = "login"
    let method: HTTPMethod = .post
    let bodyParams: [String: Any]

    init(email: String, password: String) {
        bodyParams = [
            "email": email,
            "password": password
        ]
    }
}
