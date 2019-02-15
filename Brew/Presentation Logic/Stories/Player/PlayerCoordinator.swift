//
//  PlayerCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/27/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerContainer {
    func presentMiniPlayer(_ player: AppViewController)
    func presentFullScreenPlayer(_ player: AppViewController)
}

class PlayerCoordinator: NSObject {

    private(set) var miniPlayerController: PlayerViewController?
    private(set) var fullScreenPlayerController: PlayerViewController?
    private(set) var playerData: (player: AVPlayer, token: Any)?

    private var autoContinueData: (podcast: Podcast, playingIndex: Int)?
    private var activityUpdateTimer: Timer?
    private var activeEpisode: Episode?
    private var turnOffTime: TimeInterval?

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
	func playEpisode(at index: Int, from podcast: Podcast, autoContinue: Bool = true, startFrom: Int = 0) -> Bool {

        guard let episodes = podcast.episodes, episodes.count > index else {
            return false
        }

        let episode = episodes[index]
		
        if playEpisode(episode, from: podcast, startFrom: startFrom) {
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
	func playEpisode(_ episode: Episode, from podcast: Podcast? = nil, startFrom: Int = 0) -> Bool {
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
		
		if startFrom < episode.duration {
			data.audioPlayer.currentPosition += startFrom
		}
		
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

            fullScreenPlayerController?.onShare = { [weak self] in
                self?.share()
            }

            fullScreenPlayerController?.onShowComments = { [weak self] in
                self?.showComments()
            }

            fullScreenPlayerController?.onSleep = { [weak self] in
                self?.setupSleep(after: $0)
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
		guard let serverUrl = episode.file?.url else { return nil }
		
		let url = AppFileLoader.shared.localFileUrl(for: serverUrl) ?? serverUrl
        let player = updatedPlayer(for: url)

        return PlayerViewController.Data(imageUrl: podcast.albumArt?.url,
										 title: episode.title,
										 artist: podcast.user.profile?.profileFullName ?? "",
										 description: episode.description,
										 audioPlayer: player)
    }

    private func updatedPlayer(for audioUrl: URL) -> AVPlayer {
        invalidateCurrentPlayer()

        let player = AVPlayer(url: audioUrl)
        addPlayerEndObservation(to: player)

        let token = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] _ in
            self?.checkSleepTime()
        }

        playerData = (player, token)

        return player
    }

    private func addPlayerEndObservation(to player: AVPlayer) {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    private func removePlayerEndObservation(from player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    private func checkSleepTime() {
        guard playerData != nil else {
            return
        }

        guard let turnOffTime = turnOffTime else {
            return
        }

        if turnOffTime < Date().timeIntervalSince1970 {
            invalidateCurrentData()
        }
    }

    @objc private func playerDidFinishPlaying(_ notification: NSNotification) {
        invalidateCurrentPlayer()
        playNextEpisodeIfNeeded()
    }

    private func prepareAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, policy: .longForm)
        try? audioSession.setActive(true, options: [])
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func invalidateCurrentData() {
        invalidateCurrentPlayer()
        autoContinueData = nil
    }

    private func invalidateCurrentPlayer() {
        guard let data = playerData else {
            return
        }

        data.player.removeTimeObserver(data.token)
        removePlayerEndObservation(from: data.player)
        data.player.pause()
        invalidateActivityUpdateTimer()

        playerData = nil
    }

    private func setupSleep(after seconds: Int) {
        turnOffTime = Date().timeIntervalSince1970 + TimeInterval(seconds)
    }

    private func clap() {
        guard let episode = activeEpisode else {
            return
        }

        ClapEpisodeRequest(episodeId: episode.id).execute()
    }

    private func share() {
        guard let link = activeEpisode?.shareableLink, let name = activeEpisode?.title else {
            return
        }

        let controller = UIActivityViewController(activityItems: [link, name], applicationActivities: nil)
        fullScreenPlayerController?.present(controller, animated: true)
    }

    private func showComments() {
        guard let episodeId = activeEpisode?.id else {
            return
        }

        GetEpisodeCommentsRequest(episodeId: episodeId).execute(
            onSuccess: { [weak self] in
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
