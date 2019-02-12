//
//  Comment.swift
//  Brew
//
//  Created by new user on 2/12/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let user: User
    let commentContent: String
}
