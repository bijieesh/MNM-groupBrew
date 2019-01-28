//
//  PlayerCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/27/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerCoordinator {
    static let instance = PlayerCoordinator()

    private var activeAudioPlayer: AVAudioPlayer?

    func playEpisode(at index: Int, from podcast: Podcast, completion: @escaping (AppViewController?) -> Void) {
        guard let episodes = podcast.episodes, episodes.count > index else {
            completion(nil)
            return
        }

        guard let audioUrl = podcast.episodes?[index].file?.url else {
            completion(nil)
            return
        }

        downloadFile(from: audioUrl) { [weak self] serverUrl in
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: audioUrl) else {
                completion(nil)
                return
            }

            self?.invalidateCurrentPlayer()
            self?.prepareAudioSession()

            self?.activeAudioPlayer = audioPlayer

            let data = PlayerViewController.Data(imageUrl: podcast.albumArt?.url, title: podcast.title, autoplay: true, audioPlayer: audioPlayer)
            let controller = PlayerViewController()
            controller.data = data

            completion(controller)
        }
    }

    private func downloadFile(from url: URL, completion: ((URL?) -> Void)?) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (serverUrl, response, error) in
            completion?(serverUrl)
        })

        downloadTask.resume()
    }
    
    private func prepareAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .spokenAudio)
    }

    private func invalidateCurrentPlayer() {
        activeAudioPlayer?.stop()
        activeAudioPlayer = nil
    }
}
