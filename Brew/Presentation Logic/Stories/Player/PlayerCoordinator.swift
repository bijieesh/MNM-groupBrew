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
    private var activityUpdateTimer: Timer?
    private var activeEpisode: Episode?

    private let playerContainer: PlayerContainer

    init(playerContainer: PlayerContainer) {
        self.playerContainer = playerContainer
        super.init()
        prepareAudioSession()
    }

    func invalidate() {
        invalidateCurrentData()
    }

    @discardableResult
    func playEpisode(at index: Int, from podcast: Podcast, autoContinue: Bool = true) -> Bool {

        guard let episodes = podcast.episodes, episodes.count > index else {
            return false
        }

        let episode = episodes[index]

        if playEpisode(episode, from: podcast) {
            if autoContinue {
                autoContinueData = (podcast, index)
            }
            else {
                autoContinueData = nil
            }

            return true
        }
        else {
            return false
        }
    }

    @discardableResult
    func playEpisode(_ episode: Episode, from podcast: Podcast? = nil) -> Bool {
        invalidateCurrentData()

        guard let podcast = (podcast ?? episode.podcast) else {
            return false
        }

        guard let data = playerData(for: episode, in: podcast) else {
            return false
        }

        autoContinueData = nil

        updatePlayerControllers(with: data)
        presentPlayerControllerIfNeeded()

        data.audioPlayer.play()

        setupActivityUpdateTimer(for: episode.id, data.audioPlayer)

        activeEpisode = episode

        return true
    }

    private func updatePlayerControllers(with data: PlayerViewController.Data) {
        if let miniPlayerController = miniPlayerController {
            miniPlayerController.data = data
        }
        else {
            miniPlayerController = PlayerViewController(data: data, type: .mini)
            miniPlayerController?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentFullScreenControllerIfNeeded)))
        }

        if let fullScreenPlayerController = fullScreenPlayerController {
            fullScreenPlayerController.data = data
        }
        else {
            fullScreenPlayerController = PlayerViewController(data: data, type: .fullScreen)

            fullScreenPlayerController?.onClap = { [weak self] in
                self?.clap()
            }

            fullScreenPlayerController?.onShowComments = { [weak self] in
                self?.showComments()
            }
        }
    }

    private func setupActivityUpdateTimer(for episodeId: Int, _ player: AVPlayer) {
        invalidateActivityUpdateTimer()

        activityUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self, weak player] _ in
            guard let player = player else {
                self?.invalidateActivityUpdateTimer()
                return
            }

            UpdateActivityRequest(episodeId: episodeId, duration: player.currentPosition).execute()
        }
    }

    private func invalidateActivityUpdateTimer() {
        activityUpdateTimer?.invalidate()
        activityUpdateTimer = nil
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
        playAutoContinueEpisode(at: newIndex)
    }

    private func playPreviousEpisode() {
        guard let activeData = autoContinueData else {
            return
        }

        let newIndex = max(activeData.playingIndex - 1, 0)
        playAutoContinueEpisode(at: newIndex)
    }

    private func playAutoContinueEpisode(at index: Int) {
        guard var activeData = autoContinueData else {
            return
        }

        guard let episode = activeData.podcast.episodes?[safe: index] else {
            invalidateCurrentData()
            return
        }

        playEpisode(episode, from: activeData.podcast)

        activeData.playingIndex = index
        autoContinueData = activeData
    }

    private func playerData(for episode: Episode, in podcast: Podcast) -> PlayerViewController.Data? {
        guard let audioUrl = episode.file?.url else {
            return nil
        }

        let player = AVPlayer(url: audioUrl)

        addPlayerEndObservation(to: player)

        return PlayerViewController.Data(imageUrl: podcast.albumArt?.url, title: episode.title, artist: podcast.user.profile?.profileFullName ?? "", audioPlayer: player)
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
        invalidateActivityUpdateTimer()
        autoContinueData = nil
    }

    private func invalidateCurrentPlayer() {
        guard let player = activePlayer else {
            return
        }

        removePlayerEndObservation(from: player)
        player.pause()
    }

    private func clap() {
        guard let episode = activeEpisode else {
            return
        }

        ClapEpisodeRequest(episodeId: episode.id).execute()
    }

    private func showComments() {
        guard let episodeId = activeEpisode?.id else {
            return
        }

        GetEpisodeCommentsRequest(episodeId: episodeId).execute(
            onSuccess: {  [weak self] in
                let controller = CommentsViewController()
                controller.comments = $0

                controller.onAddComment = { [weak controller] in
                    AddEpisodeCommentRequest(episodeId: episodeId, comment: $0).execute()
                    controller?.dismiss(animated: true)
                }

                controller.onClose = { [weak controller] in
                    controller?.dismiss(animated: true)
                }

                self?.fullScreenPlayerController?.present(controller, animated: true)
        },
            onError: {
                $0.display()
        })
    }
}
