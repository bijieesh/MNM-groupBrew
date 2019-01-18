//
//  LoginRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
}

struct LoginRequest: RequestType {
    typealias ResponseObjectType = LoginResponse
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
