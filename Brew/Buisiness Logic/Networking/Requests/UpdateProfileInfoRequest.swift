//
//  UpdateProfileInfo.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/26/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct UpdateProfileInfoRequest: RequestType {
    typealias ResponseObjectType = User
    typealias ErrorType = SimpleError
    
    let path = "profile"
    let method: HTTPMethod = .post
    var bodyParams: [String: Any]
    
    init(fullname: String, email: String, mobile: String?, country: String) {
        bodyParams = [
            "email": email,
            "fullname": fullname,
            "country": country
        ]
        if let mobile = mobile {
            bodyParams["mobile"] = mobile
        }
    }
}
