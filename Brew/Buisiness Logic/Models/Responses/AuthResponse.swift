//
//  AuthResponse.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct AuthResponse: Codable {
    let user: User
    let success: Bool
    let token: String
}
