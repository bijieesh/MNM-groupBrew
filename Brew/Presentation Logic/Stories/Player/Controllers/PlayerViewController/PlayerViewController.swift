//
//  PlayerViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/23/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import LDProgressView
import AVFoundation
import SDWebImage

private extension AVPlayer {
    var isPlaying: Bool {
        return rate == 0
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

class PlayerViewController: AppViewController {
    struct Data {
        let imageUrl: URL?
        let title: String
        let autoplay: Bool
        let audioPlayer: AVPlayer
    }

    var onPlayListTapped: (() -> Void)?

    var data: Data?

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var artistNameLabel: UILabel!
    @IBOutlet private var currentTimeLabel: UILabel!
    @IBOutlet private var songFullTimeLabel: UILabel!
    @IBOutlet private var unmuteButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var rateLabel: UILabel!
    
    @IBOutlet private var progressView: LDProgressView! {
        didSet {
            progressView.progress = 0.0
            progressView.color = .appOrange
            progressView.animate = false
            progressView.borderRadius = 0
            progressView.type = LDProgressSolid
            progressView.showText = false
            progressView.background = .lightGray
            progressView.showBackgroundInnerShadow = false
        }
    }
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data = data else {
            return
        }

        songFullTimeLabel.text = TimeWatch(totalSeconds: data.audioPlayer.duration).timeString

        if let imageUrl = data.imageUrl {
            imageView.sd_setImage(with: imageUrl)
        }
        
        songNameLabel.text = data.title
        artistNameLabel.text = data.title
        
        if data.autoplay {
            data.audioPlayer.play()
            setupTimer()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()
    }

    private func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer?.fire()
    }

    private func updateUI() {
        guard let data = data, isViewLoaded else {
            return
        }

        let playIcon: UIImage? = data.audioPlayer.isPlaying ? .pauseImage : .playImage
        playButton.setImage(playIcon, for: .normal)

        let muteIcon: UIImage? = data.audioPlayer.isMuted ? .mutedImage : .unmutedImage
        unmuteButton.setImage(muteIcon, for: .normal)

        updateTime()
        updateRateLabel()
    }

    @objc private func updateTime() {
        guard let data = data else {
            return
        }

        let currentTime = data.audioPlayer.currentPosition
        let totalTime = max(data.audioPlayer.duration, 1)


        let currentSongTime = TimeWatch(totalSeconds: currentTime)

        self.progressView.progress = CGFloat(currentTime / totalTime)
        self.currentTimeLabel.text = currentSongTime.timeString
    }

    private func play() {
        data?.audioPlayer.play()
        setupTimer()
    }

    private func pause() {
        data?.audioPlayer.pause()
        timer?.invalidate()
    }

    private func updateRateLabel() {
        if let rate = data?.audioPlayer.rate {
            rateLabel.text = String(rate)
        }
        else {
            rateLabel.text = "1.0"
        }
    }

    //Actions
    @IBAction private func playlistTapped() {
        onPlayListTapped?()
    }
    
    @IBAction private func palyTapped() {
        if data?.audioPlayer.isPlaying == true {
            pause()
        } else {
            play()
        }

        updateUI()
    }

    @IBAction private func backPressed() {
        onClose?()
    }

    @IBAction private func replayTapped() {
        data?.audioPlayer.currentPosition -= 30
        updateTime()
        
    }
    @IBAction private func forvardTapped() {
        data?.audioPlayer.currentPosition += 30
        updateTime()
    }
    
    @IBAction private func unmuteTapped() {
        data?.audioPlayer.isMuted = data?.audioPlayer.isMuted == false
        updateUI()
    }

    @IBAction private func ratePlusPressed() {
        let currentRate = data?.audioPlayer.rate ?? 0
        data?.audioPlayer.rate = min(2, currentRate + 0.25)
        updateRateLabel()
    }

    @IBAction private func rateMinusPressed() {
        let currentRate = data?.audioPlayer.rate ?? 0
        data?.audioPlayer.rate = max(0, currentRate - 0.25)
        updateRateLabel()
    }
}

private extension AVAudioPlayer {
    var isMuted: Bool {
        set { volume = newValue ? 0 : 1 }
        get { return volume == 0 }
    }
}

private struct TimeWatch {
    
    var totalSeconds: Int
    
    var hours: Int {
        return (totalSeconds % 86400) / 3600
    }
    
    var minutes: Int {
        return (totalSeconds % 3600) / 60
    }
    
    var seconds: Int {
        return totalSeconds % 60
    }
    
    var timeString: String {
        
        let hoursText = timeText(from: hours)
        let minutesText = timeText(from: minutes)
        let secondsText = timeText(from: seconds)
        
        if hours > 0 {
            return "\(hoursText):\(minutesText):\(secondsText)"
        } else
            if hours == 0 && minutes > 0 {
                return "\(minutesText):\(secondsText)"
        }
        return "\(minutesText):\(secondsText)"
    }
    
    private func timeText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}

private extension UIImage {
    static let mutedImage = UIImage(named: "muteIcon")
    static let unmutedImage = UIImage(named: "unMuteIcon")
    
    static let pauseImage = UIImage(named: "pause")
    static let playImage = UIImage(named: "playIcon")
    
}
