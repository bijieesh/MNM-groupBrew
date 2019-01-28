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

class PlayerViewController: AppViewController {
    struct Data {
        let imageUrl: URL?
        let title: String
        let autoplay: Bool
        let audioPlayer: AVAudioPlayer
    }

    var onPlayListTapped: (() -> Void)?
    var onBackPressed: ((PlayerViewController) -> Void)?

    var data: Data?

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var artistNameLabel: UILabel!
    @IBOutlet private var currentTimeLabel: UILabel!
    @IBOutlet private var songFullTimeLabel: UILabel!
    @IBOutlet private var unmuteButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    
    @IBOutlet private var progressView: LDProgressView! {
        didSet {
            progressView.progress = 0.0
            progressView.color = .red
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

        songFullTimeLabel.text = TimeWatch(totalSeconds: Int(data.audioPlayer.duration)).timeString

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
        guard let data = data else {
            return
        }

        let playIcon: UIImage? = data.audioPlayer.isPlaying ? .pauseImage : .playImage
        playButton.setImage(playIcon, for: .normal)

        let muteIcon: UIImage? = data.audioPlayer.isMuted ? .mutedImage : .unmutedImage
        unmuteButton.setImage(muteIcon, for: .normal)

        updateTime()
    }

    @objc private func updateTime() {
        guard let data = data else {
            return
        }

        let currentSongTime = TimeWatch(totalSeconds: Int(data.audioPlayer.currentTime))

        self.progressView.progress = CGFloat(data.audioPlayer.currentTime / data.audioPlayer.duration)
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
        data?.audioPlayer.stop()
        onBackPressed?(self)
    }

    @IBAction private func replayTapped() {
        data?.audioPlayer.currentTime -= 30.0
        updateTime()
        
    }
    @IBAction private func forvardTapped() {
        data?.audioPlayer.currentTime += 30.0
        updateTime()
    }
    
    @IBAction private func unmuteTapped() {
        data?.audioPlayer.isMuted = data?.audioPlayer.isMuted == false
        updateUI()
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
