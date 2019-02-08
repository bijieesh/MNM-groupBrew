//
//  PlayerBaseViewController.swift
//  Brew
//
//  Created by Vasy Khmil on 2/8/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

private extension AVPlayer {
    var isPlaying: Bool {
        return rate == 1
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

class PlayerBaseViewController: AppViewController {
    
}
