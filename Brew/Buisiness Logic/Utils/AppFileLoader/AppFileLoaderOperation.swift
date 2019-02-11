//
//  AppFileLoaderOperation.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/10/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

protocol AppFileLoaderProgressHandler: class {
    var progress: Float { get set }
}

class AppFileLoaderOperation: Operation, URLSessionDownloadDelegate {

    let url: URL
    let localUrl: URL

    private var downloadTask: URLSessionDownloadTask?

    private(set) var progress: Float = 0 {
        didSet {
            sendProgressUpdate()
        }
    }

    var progressHandler: AppFileLoaderProgressHandler? {
        didSet {
            sendProgressUpdate()
        }
    }

    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .current)
        return session
    }()

    init(url: URL, localUrl: URL, progressHandler: AppFileLoaderProgressHandler? = nil) {
        self.url = url
        self.localUrl = localUrl
        self.progressHandler = progressHandler
    }

    override func main() {
        downloadTask = urlSession.downloadTask(with: url)

        progress = 0
        downloadTask?.resume()
    }

    override func cancel() {
        downloadTask?.cancel()
        super.cancel()
    }

    private func sendProgressUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.progressHandler?.progress = strongSelf.progress
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        try? FileManager.default.moveItem(at: location, to: localUrl)
        progress = 1
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress = Float(totalBytesExpectedToWrite) / Float(totalBytesWritten)
    }
}
