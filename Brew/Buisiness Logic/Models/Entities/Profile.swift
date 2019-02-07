//
//  Profile.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/26/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let profileFirstName: String
    let profileFullName: String
    let profilePicture: File?
}
