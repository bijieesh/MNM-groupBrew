//
//  SimpleError.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct SimpleError: CodableError {
    let error: String

    var localizedDescription: String {
        return error
    }
}
