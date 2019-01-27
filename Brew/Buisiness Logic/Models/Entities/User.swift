//
//  User.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class User: Codable {
    let id: Int
    let name: String
    let email: String
    let country: String
    let phoneNumber: String?
    let profile: Profile
    let podcasts: [Podcast]
}
