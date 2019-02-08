//
//  PlayerCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/27/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerContainer {
    func presentMiniPlayer(_ player: AppViewController)
    func presentFullScreenPlayer(_ player: AppViewController)
}

class PlayerCoordinator: NSObject {

    private(set) var miniPlayerController: PlayerViewController?
    private(set) var fullScreenPlayerController: PlayerViewController?
    private(set) var activePlayer: AVPlayer?

    private var autoContinueData: (podcast: Podcast, playingIndex: Int)?

    private let playerContainer: PlayerContainer

    init(playerContainer: PlayerContainer) {
        self.playerContainer = playerContainer
        super.init()
        prepareAudioSession()
    }

    @discardableResult
    func playEpisode(at index: Int, from podcast: Podcast, autoContinue: Bool = true) -> Bool {
        invalidateCurrentData()

        guard let episodes = podcast.episodes, episodes.count > index else {
            return false
        }

        guard let data = playerData(for: episodes[index], in: podcast, autoContinue: autoContinue) else {
            return false
        }

        updatePlayerControllers(with: data)

        if autoContinue {
            autoContinueData = (podcast, index)
        }
        else {
            autoContinueData = nil
        }

        presentPlayerControllerIfNeeded()

        return true
    }

    private func updatePlayerControllers(with data: PlayerViewController.Data) {
        if let miniPlayerController = miniPlayerController {
            miniPlayerController.data = data
        }
        else {
            miniPlayerController = PlayerViewController(data: data, type: .mini, autoplay: false)
            miniPlayerController?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentFullScreenControllerIfNeeded)))
        }

        if let fullScreenPlayerController = fullScreenPlayerController {
            fullScreenPlayerController.data = data
        }
        else {
            fullScreenPlayerController = PlayerViewController(data: data, type: .fullScreen, autoplay: true)
        }
    }

    private func presentPlayerControllerIfNeeded() {
        if let miniPlayerController = miniPlayerController, miniPlayerController.view.window == nil {
            playerContainer.presentMiniPlayer(miniPlayerController)
        }

        presentFullScreenControllerIfNeeded()
    }

    @objc private func presentFullScreenControllerIfNeeded() {
        if let fullScreenPlayerController = fullScreenPlayerController, fullScreenPlayerController.view.window == nil {
            playerContainer.presentFullScreenPlayer(fullScreenPlayerController)
        }
    }

    private func playNextEpisodeIfNeeded() {
        guard let activeData = autoContinueData else {
            return
        }

        let newIndex = activeData.playingIndex + 1
        playEpisode(at: newIndex)
    }

    private func playPreviousEpisode() {
        guard let activeData = autoContinueData else {
            return
        }

        let newIndex = max(activeData.playingIndex - 1, 0)
        playEpisode(at: newIndex)
    }

    private func playEpisode(at index: Int) {
        guard let activeData = autoContinueData else {
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

        fullScreenPlayerController?.data = data
        miniPlayerController?.data = data
        activePlayer = data.audioPlayer

        autoContinueData?.playingIndex = index
    }

    private func playerData(for episode: Episode, in podcast: Podcast, autoContinue: Bool) -> PlayerViewController.Data? {
        guard let audioUrl = episode.file?.url else {
            return nil
        }

        let player = AVPlayer(url: audioUrl)

        if autoContinue {
            addPlayerEndObservation(to: player)
        }

        return PlayerViewController.Data(imageUrl: podcast.albumArt?.url, title: episode.title, artist: podcast.user.profile.profileFullName, audioPlayer: player)
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
        playNextEpisodeIfNeeded()
    }

    private func prepareAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, policy: .longForm)
        try? audioSession.setActive(true, options: [])
    }

    private func invalidateCurrentData() {
        invalidateCurrentPlayer()
        autoContinueData = nil
    }

    private func invalidateCurrentPlayer() {
        guard let player = activePlayer else {
            return
        }

        removePlayerEndObservation(from: player)
        player.pause()
    }
}
