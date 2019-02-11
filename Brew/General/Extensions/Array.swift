//
//  Array.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/11/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
