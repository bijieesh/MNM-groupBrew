//
//  Category.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/25/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
	let file: File?
}
