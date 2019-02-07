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

class PlayerViewController: AppViewController {
    struct Data {
        let imageUrl: URL?
        let title: String
        let audioPlayer: AVPlayer
    }

    enum `Type` {
        case fullScreen
        case mini

        var nibName: String {
            switch self {
            case .fullScreen: return "PlayerViewControllerFullScreen"
            case .mini: return "PlayerViewControllerMini"
            }
        }
    }

    var onPlayListTapped: (() -> Void)?

    var data: Data {
        didSet {
            updateFlow()
        }
    }

    private var autoplay: Bool = false

    @IBOutlet weak private var imageView: UIImageView?
    @IBOutlet weak private var songNameLabel: UILabel?
    @IBOutlet weak private var artistNameLabel: UILabel?
    @IBOutlet weak private var currentTimeLabel: UILabel?
    @IBOutlet weak private var songFullTimeLabel: UILabel?
    @IBOutlet weak private var unmuteButton: UIButton?
    @IBOutlet weak private var playButton: UIButton?
    @IBOutlet weak private var rateLabel: UILabel?
    
    @IBOutlet weak private var progressView: LDProgressView? {
        didSet {
            progressView?.progress = 0.0
            progressView?.color = .appOrange
            progressView?.animate = false
            progressView?.borderRadius = 0
            progressView?.type = LDProgressSolid
            progressView?.showText = false
            progressView?.background = .lightGray
            progressView?.showBackgroundInnerShadow = false
        }
    }

    private var playerObservationToken: Any?

    init(data: Data, type: Type, autoplay: Bool = true) {
        self.data = data
        self.autoplay = autoplay
        super.init(nibName: type.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateFlow()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObservaton()
    }

    private func updateFlow() {
        guard isViewLoaded else {
            return
        }

        songFullTimeLabel?.text = TimeWatch(totalSeconds: data.audioPlayer.duration).timeString

        if let imageUrl = data.imageUrl {
            imageView?.sd_setImage(with: imageUrl)
        }

        songNameLabel?.text = data.title
        artistNameLabel?.text = data.title

        if autoplay {
            data.audioPlayer.play()
        }
    }

    private func setupObservaton() {
        playerObservationToken = data.audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] _ in
            self?.updatePlayerUI()
        }

        updatePlayerUI()
    }

    private func invalidateObservation() {
        if let token = playerObservationToken {
            data.audioPlayer.removeTimeObserver(token)
            playerObservationToken = nil
        }
    }

    private func updatePlayerUI() {
        guard isViewLoaded else {
            return
        }

        let playIcon: UIImage? = data.audioPlayer.isPlaying ? .pauseImage : .playImage
        playButton?.setImage(playIcon, for: .normal)

        let muteIcon: UIImage? = data.audioPlayer.isMuted ? .mutedImage : .unmutedImage
        unmuteButton?.setImage(muteIcon, for: .normal)

        updateTime()
        updateRateLabel()
    }

    @objc private func updateTime() {

        let currentTime = data.audioPlayer.currentPosition
        let totalTime = max(data.audioPlayer.duration, 1)


        let currentSongTime = TimeWatch(totalSeconds: currentTime)

        progressView?.progress = CGFloat(currentTime) / CGFloat(totalTime)
        currentTimeLabel?.text = currentSongTime.timeString
    }

    private func play() {
        data.audioPlayer.play()
    }

    private func pause() {
        data.audioPlayer.pause()
    }

    private func updateRateLabel() {
        rateLabel?.text = String(data.audioPlayer.rate)
    }

    //Actions
    @IBAction private func playlistTapped() {
        onPlayListTapped?()
    }
    
    @IBAction private func palyTapped() {
        if data.audioPlayer.isPlaying == true {
            pause()
        } else {
            play()
        }

        updatePlayerUI()
    }

    @IBAction private func backPressed() {
        onClose?()
    }

    @IBAction private func replayTapped() {
        data.audioPlayer.currentPosition -= 30
        updateTime()
        
    }
    @IBAction private func forvardTapped() {
        data.audioPlayer.currentPosition += 30
        updateTime()
    }
    
    @IBAction private func unmuteTapped() {
        data.audioPlayer.isMuted = data.audioPlayer.isMuted == false
        updatePlayerUI()
    }

    @IBAction private func ratePlusPressed() {
        let currentRate = data.audioPlayer.rate
        data.audioPlayer.rate = min(2, currentRate + 0.25)
        updateRateLabel()
    }

    @IBAction private func rateMinusPressed() {
        let currentRate = data.audioPlayer.rate
        data.audioPlayer.rate = max(0, currentRate - 0.25)
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
