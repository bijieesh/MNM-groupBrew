//
//  AVPlayer.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/11/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate > 0
    }

    var currentPosition: Int {
        get {
            let time = currentItem?.currentTime().seconds ?? 0

            if time.isNaN {
                return 0
            }
            else {
                return Int(time)
            }
        }

        set {
            let time = CMTime(seconds: Double(newValue), preferredTimescale: 1)
            currentItem?.seek(to: time, completionHandler: nil)
        }
    }

    var duration: Int {
        let time = currentItem?.duration.seconds ?? 0

        if time.isNaN {
            return 0
        }
        else {
            return Int(time)
        }
    }
}
