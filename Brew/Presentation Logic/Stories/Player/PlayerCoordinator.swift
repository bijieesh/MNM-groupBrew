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

    @discardableResult
    func playEpisode(at index: Int, from podcast: Podcast) -> AppViewController? {
        guard let episodes = podcast.episodes, episodes.count > index else {
            return nil
        }

        guard let url = episodes[index].file?.url, let audioPlayer = try? AVAudioPlayer(contentsOf: url) else {
            return nil
        }

        invalidateCurrentPlayer()
        prepareAudioSession()

        let data = PlayerViewController.Data(imageUrl: nil, title: podcast.title, autoplay: true, audioPlayer: audioPlayer)
        let controller = PlayerViewController()
        controller.data = data

        return controller
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
