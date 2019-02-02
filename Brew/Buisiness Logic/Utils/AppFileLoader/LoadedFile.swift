//
//  LoadedFile.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/2/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class LoadedFile {
    let remoteUrl: URL
    private let progressHandler: FileLoaderProgressHandler?

    var localUrl: URL? {
        return AppFileLoader.shared.localFileUrl(for: remoteUrl)
    }

    init(remoteUrl: URL, progressHandler: FileLoaderProgressHandler? = nil) {
        self.remoteUrl = remoteUrl
        self.progressHandler = progressHandler
    }

    func delete() {
        AppFileLoader.shared.deleteFile(for: remoteUrl)
    }

    func store(completion: ((Bool) -> Void)? = nil) {
        AppFileLoader.shared.storeFile(from: remoteUrl, progressHandler: progressHandler, completion: completion)
    }
}
