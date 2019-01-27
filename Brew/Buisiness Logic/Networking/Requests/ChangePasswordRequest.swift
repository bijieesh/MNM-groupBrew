//
//  ChangePasswordRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/26/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct ChangePasswordRequest: RequestType {
    typealias ResponseObjectType = User
    typealias ErrorType = SimpleError
    
    let path = "api/reset_password"
    let method: HTTPMethod = .post
    let bodyParams: [String: Any]
    
    init(oldPassword: String, newPassword: String) {
        bodyParams = [
            "password": newPassword,
            "old_password": oldPassword
        ]
    }
}
