//
//  SimpleError.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SimpleError: ServerError {
    let error: String

    var message: String {
        return error
    }
}

struct MessageError: ServerError {
    let message: String
}
