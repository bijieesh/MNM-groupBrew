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
    typealias ActiveData = (controller: PlayerViewController, miniController: PlayerViewController, podcast: Podcast, episodeIndex: Int, player: AVPlayer)

    private var activeData: ActiveData?

    @discardableResult
    func playEpisode(at index: Int, from podcast: Podcast, autoContinue: Bool = true) -> ActiveData? {
        invalidateCurrentData()

        guard let episodes = podcast.episodes, episodes.count > index else {
            return nil
        }

        guard let data = playerData(for: episodes[index], in: podcast, autoContinue: autoContinue) else {
            return nil
        }

        prepareAudioSession()

        let controller = PlayerViewController(data: data, type: .fullScreen, autoplay: true)
        let miniController = PlayerViewController(data: data, type: .mini, autoplay: false)

        activeData = (controller, miniController, podcast, index, data.audioPlayer)

        return activeData
    }

    private func playNextEpisode() {
        guard let activeData = activeData else {
            return
        }

        let newIndex = activeData.episodeIndex + 1
        playEpisode(at: newIndex)
    }

    private func playPreviousEpisode() {
        guard let activeData = activeData else {
            return
        }

        let newIndex = max(activeData.episodeIndex - 1, 0)
        playEpisode(at: newIndex)
    }

    private func playEpisode(at index: Int) {
        guard let activeData = activeData else {
            return
        }

        guard let episodes = activeData.podcast.episodes, episodes.count > index, index >= 0 else {
            return
        }

        guard let data = playerData(for: episodes[index], in: activeData.podcast, autoContinue: true) else {
            invalidateCurrentData()
            return
        }

        invalidateCurrentPlayer()

        self.activeData?.controller.data = data
        self.activeData?.miniController.data = data
        self.activeData?.player = data.audioPlayer
        self.activeData?.episodeIndex = index
    }

    private func playerData(for episode: Episode, in podcast: Podcast, autoContinue: Bool) -> PlayerViewController.Data? {
        guard let audioUrl = episode.file?.url else {
            return nil
        }

        let player = AVPlayer(url: audioUrl)

        if autoContinue {
            addPlayerEndObservation(to: player)
        }

        return PlayerViewController.Data(imageUrl: podcast.albumArt?.url, title: podcast.title, audioPlayer: player)
    }

    private func addPlayerEndObservation(to player: AVPlayer) {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    private func removePlayerEndObservation(from player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    @objc private func playerDidFinishPlaying(_ notification: NSNotification) {
        invalidateCurrentPlayer()
        playNextEpisode()
    }

    private func prepareAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, policy: .longForm)
        try? audioSession.setActive(true, options: [])
    }

    private func invalidateCurrentData() {
        invalidateCurrentPlayer()
        activeData = nil
    }

    private func invalidateCurrentPlayer() {
        guard let player = activeData?.player else {
            return
        }

        removePlayerEndObservation(from: player)
        player.pause()
    }
}
