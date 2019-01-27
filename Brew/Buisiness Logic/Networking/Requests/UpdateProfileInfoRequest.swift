//
//  UpdateProfileInfoRequest.swift
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
    let bodyParams: [String: Any]
    
    init(fullname: String, email: String, mobile: String?, country: String) {
        var bodyParams = [
            "email": email,
            "fullname": fullname,
            "country": country
        ]
        if let mobile = mobile {
            bodyParams["phone_number"] = mobile
        }

        self.bodyParams = bodyParams
    }
    
    func convert(_ serverJson: Any, for statusCode: StatusCode) -> Any {
        guard let expectedJson = serverJson as? [String: Any], let userJson = expectedJson["user"] as? [String: Any], statusCode.isSuccessful else {
            return serverJson
        }
        
        return userJson
    }
}
