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
import  WatchConnectivity
class PlayerViewController: AppViewController,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("test")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
         print("test")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
         print("test")
    }
    
    struct Data {
        let imageUrl: URL?
        let title: String
        let artist: String
		let description: String
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
    var onClap: (() -> Void)?
    var onShowComments: (() -> Void)?
    var onShare: (() -> Void)?
    var onSleep: ((Int) -> Void)?

    var data: Data {
        willSet {
            invalidateObservation()
        }

        didSet {
            updateFlow()
        }
    }

    @IBOutlet weak private var imageView: UIImageView?
    @IBOutlet weak private var songNameLabel: UILabel?
    @IBOutlet weak private var artistNameLabel: UILabel?
    @IBOutlet weak private var currentTimeLabel: UILabel?
	@IBOutlet weak private var descriptionLabel: UILabel?
    @IBOutlet weak private var songFullTimeLabel: UILabel?
    @IBOutlet weak private var unmuteButton: UIButton?
    @IBOutlet weak private var playButton: UIButton?
    @IBOutlet weak private var rateLabel: UILabel?
    var wcsession : WCSession!
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

    init(data: Data, type: Type) {
        self.data = data
        super.init(nibName: type.nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateFlow()
        wcsession = WCSession.default
        wcsession.delegate = self
        wcsession.activate()

    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let messageStatus = message["action"] as! String
        
        if messageStatus == "play"{
            data.audioPlayer.play()
        }
        if messageStatus == "pause"{
            data.audioPlayer.pause()
        }
        
        if messageStatus == "seekbackward30second"{
            data.audioPlayer.currentPosition -= 30
            updateTime()
        }
        if messageStatus == "seekforwordward30second"{
            data.audioPlayer.currentPosition += 30
            updateTime()
        }
        
        
        print(message)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObservaton()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
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
        artistNameLabel?.text = data.artist
		descriptionLabel?.text = data.description
      
        if view.window != nil {
            setupObservaton()
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
        songFullTimeLabel?.text = TimeWatch(totalSeconds: totalTime).timeString
    }

    private func play() {
        data.audioPlayer.play()
        let stringsend = ["playerStatus" : "playaction","SongName" : songNameLabel?.text]
        if self.wcsession.isPaired == true && self.wcsession.isWatchAppInstalled == true{
            self.wcsession.sendMessage(stringsend as [String : Any], replyHandler: nil, errorHandler:{ error in
                print(error.localizedDescription)
            })
        }
    }

    private func pause() {
        data.audioPlayer.pause()
        let stringsend = ["playerStatus" : "pauseaction" , "SongName" : songNameLabel?.text]
        if self.wcsession.isPaired == true && self.wcsession.isWatchAppInstalled == true{
            self.wcsession.sendMessage(stringsend as [String : Any], replyHandler: nil, errorHandler:{ error in
                print(error.localizedDescription)
            })
        }
        
    }

    private func updateRateLabel() {
        rateLabel?.text = String(data.audioPlayer.rate)
    }

    private func showSleepOptions() {
        let controller = UIAlertController(title: "Sleep timer", message: "Chose when do you want to turn player off", preferredStyle: .actionSheet)

        controller.addAction(UIAlertAction(title: "15 min", style: .default, handler: { [weak self] _ in self?.onSleep?(15*60) }))
        controller.addAction(UIAlertAction(title: "30 min", style: .default, handler: { [weak self] _ in self?.onSleep?(30*60) }))
        controller.addAction(UIAlertAction(title: "1 hour", style: .default, handler: { [weak self] _ in self?.onSleep?(60*60) }))
        controller.addAction(UIAlertAction(title: "1 hour 30 min", style: .default, handler: { [weak self] _ in self?.onSleep?(90*60) }))
        controller.addAction(UIAlertAction(title: "2 hours", style: .default, handler: { [weak self] _ in self?.onSleep?(2*60*60) }))

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(controller, animated: true)
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

    @IBAction private func clapPressed() {
        onClap?()
    }

    @IBAction private func commentPressed() {
        onShowComments?()
    }

    @IBAction private func sharePressed() {
        onShare?()
    }

    @IBAction private func sleapTimerPressed() {
        showSleepOptions()
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
