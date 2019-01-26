//
//  ProfilePicture.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/26/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class ProfilePicture: Codable {
    
    private let upload_path: String
    private let upload_filename: String
    private let upload_extension: String
    
    var url: String {
        return upload_path + upload_filename + upload_extension
    }
}
