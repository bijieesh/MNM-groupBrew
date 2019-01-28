//
//  HomeCoordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class HomeCoordinator: NavigationCoordinator {

    override func start() {
        super.start()
        setupHomeController()
    }

    private func setupHomeController() {
        let homeController = HomeViewController()

        homeController.onPodcastSelected = { [weak self] in
            self?.showPodcastDetails(for: $0)
        }

        navigationController?.pushViewController(homeController, animated: true)

        loadHomeContent(for: homeController)
    }

    private func showPodcastDetails(for podcast: Podcast) {
        let controller = PodcastDetailViewController()
        controller.podcast = podcast

        controller.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        controller.onEpisodeSelected = { [weak self] index in
            self?.playEpisode(at: index, from: podcast)
        }

        navigationController?.pushViewController(controller, animated: true)
    }

    private func playEpisode(at index: Int, from podcast: Podcast) {
        guard let episodes = podcast.episodes, episodes.count > index else {
            return
        }
        guard let url = episodes[index].file?.url else {
            return
        }
        downloadFileFromURL(url: url) { [weak self] audioUrl in
            guard let audioUrl = audioUrl else { return }
            self?.configurePayer(for: index, from: podcast, audioUrl: audioUrl)
        }
    }
    
    func downloadFileFromURL(url: URL, completion: ((URL?)-> Void)?) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (serverurl, response, error) in
            completion?(serverurl)
        })
        
        downloadTask.resume()
    }
    
    private func configurePayer(for index: Int, from podcast: Podcast, audioUrl: URL) {
        guard let controller = PlayerCoordinator.instance.playEpisode(at: index, from: podcast, audioUrl: audioUrl) else {
            return
        }
        
        controller.onClose = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    private func loadHomeContent(for controller: HomeViewController) {
        var discoverPodcasts: [Podcast] = []
        var popularPodcasts: [Podcast] = []
        var newPodcasts: [Podcast] = []
        var editorsPodcasts: [Podcast] = []

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        GetPodcastsRequest(type: .discover).execute(onSuccess: {
            discoverPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        GetPodcastsRequest(type: .popular).execute(onSuccess: {
            popularPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        GetPodcastsRequest(type: .new).execute(onSuccess: {
            newPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        GetPodcastsRequest(type: .editors).execute(onSuccess: {
            editorsPodcasts = $0
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            controller.update(withDiscover: discoverPodcasts, popular: popularPodcasts, new: newPodcasts, editors: editorsPodcasts)
        }
    }
}
