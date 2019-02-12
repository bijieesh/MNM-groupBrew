//
//  Podcast.swift
//  Brew
//
//  Created by new user on 1/24/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

struct Podcast: Codable {
    let id: Int
    let title: String
    let description: String
    let episodes: [Episode]?
    let albumArt: File?
    let user: User
	let categories: [Category]?
	let totalRating: Int
	let likesCount: Int

    private(set) var isFollowing: Bool

    var episodesCount: Int {
        return episodes?.count ?? 0
    }

    mutating func handleSubscribe() {
        isFollowing = true
    }

    mutating func handleUnsubscribe() {
        isFollowing = false
    }
}
