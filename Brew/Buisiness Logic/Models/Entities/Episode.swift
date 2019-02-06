//
//  Episode.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/27/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let title: String
    let description: String
    let file: File?
}
