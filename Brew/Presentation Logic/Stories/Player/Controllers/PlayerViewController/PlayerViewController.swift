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

class PlayerViewController: UIViewController {
    
    var onPlayListTapped:(()->Void)?
    
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var autorNameLabel: UILabel!
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
    private var isMuted = false {
        didSet {
            let icon: UIImage? = isMuted ? .mutedImage : .unmutedImage
            unmuteButton.setImage(icon, for: .normal)
            audioPlayer.volume = isMuted ? 0 : 1
            
        }
    }
    
    private var isPlay = false {
        didSet {
            let icon: UIImage? = isPlay ? .pauseImage : .playImage
            playButton.setImage(icon, for: .normal)
        }
    }
    
    private var audioPlayer = AVAudioPlayer() {
        didSet {
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                //audio background mode
                try audioSession.setCategory(.playback, mode: .spokenAudio)
            } catch {
                
            }
        }
    }
    private var urlString: String? {
        didSet {
            downloadFileFromURL(url: urlString ?? "")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        urlString = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
    }
    
    //Actions
    @IBAction private func playlistTapped() {
        onPlayListTapped?()
    }
    
    @IBAction private func palyTapped() {
        //fix app crash if audio didnt load yet but play button tapped
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
        isPlay = !isPlay
        updateTime()
    }
    @IBAction private func replayTapped() {
        self.audioPlayer.currentTime -= 30.0
        updateTime()
        
    }
    @IBAction private func forvardTapped() {
        self.audioPlayer.currentTime += 30.0
        updateTime()
    }
    
    @IBAction private func unmuteTapped() {
        isMuted = !isMuted
    }
    
    private func updateTime() {
        let totalSongTime = TimeWatch(totalSeconds: Int(self.audioPlayer.duration))
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let currentSongTime = TimeWatch(totalSeconds: Int(self.audioPlayer.currentTime))
            
            self.progressView.progress = CGFloat(self.audioPlayer.currentTime / self.audioPlayer.duration)
            self.currentTimeLabel.text = currentSongTime.timeString
        }
        self.timer = timer
        songFullTimeLabel.text = totalSongTime.timeString
    }
    
    private func downloadFileFromURL(url:String){
        guard let url = URL(string: url) else {
            print("Something wrong with url link")
            return
        }
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) in
            guard let URL = URL else {
                print("Something wrong with url link")
                return
            }
            self.play(url:URL as NSURL)
            
        })
        downloadTask.resume()
    }
    
    private func play(url:NSURL) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}

//remove from controller or find lib that can return this values
struct TimeWatch {
    
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

extension UIImage {
    static let mutedImage = UIImage(named: "muteIcon")
    static let unmutedImage = UIImage(named: "unMuteIcon")
    
    static let pauseImage = UIImage(named: "pause")
    static let playImage = UIImage(named: "playIcon")
    
}
