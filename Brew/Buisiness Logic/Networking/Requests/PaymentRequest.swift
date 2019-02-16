//
//  PaymentRequest.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/16/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct PaymentRequest: RequestType {
    typealias ResponseObjectType = StatusResponse
    typealias ErrorType = SimpleError

    let path: String = "api/user/pay"
    let method: HTTPMethod = .post
    let bodyParams: [String : Any]

    init(productId: String, transactionId: String) {
        bodyParams = [
            "product_id": productId,
            "transaction_id": transactionId
        ]
    }
}
