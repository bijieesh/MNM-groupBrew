//
//  File.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/27/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct File: Codable {
    let id: Int
    let uploadPath: String
    let uploadFilename: String
    let uploadExtension: String

    var url: URL? {
        guard let baseUrl = NetworkingStack.instance.photoUrl else {
            return nil
        }

        let urlString = baseUrl + uploadPath + uploadFilename + uploadExtension
        return URL(string: urlString)
    }
}
