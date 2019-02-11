//
//  Activity.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/11/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct Activity: Codable {
	var id: Int
	var duration: Int
	var episode: Episode
}
