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

    private var activeAudioPlayer: AVPlayer?

    func playEpisode(at index: Int, from podcast: Podcast) -> AppViewController? {
        guard let episodes = podcast.episodes, episodes.count > index else {
            return nil
        }

        guard let audioUrl = podcast.episodes?[index].file?.url else {
            return nil
        }

        invalidateCurrentPlayer()
        prepareAudioSession()

        let player = AVPlayer(url: audioUrl)
        activeAudioPlayer = player

        let data = PlayerViewController.Data(imageUrl: podcast.albumArt?.url, title: podcast.title, autoplay: true, audioPlayer: player)
        let controller = PlayerViewController()
        controller.data = data

        return controller
    }
    
    private func prepareAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, policy: .longForm)
        try? audioSession.setActive(true, options: [])
    }

    private func invalidateCurrentPlayer() {
        activeAudioPlayer?.pause()
        activeAudioPlayer = nil
    }
}
