//
//  AppFileLoader.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/2/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

protocol FileLoaderProgressHandler: class {
    var progress: Float { get set }
}

class AppFileLoader: NSObject {
    private typealias LoadInfo = (operation: Operation, task: URLSessionDownloadTask, progressHandler: FileLoaderProgressHandler?)

    static let shared = AppFileLoader()

    private let queue = OperationQueue()
    private let fileManager = FileManager.default

    private var activeLoads: [LoadInfo] = []

    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .current)
        return session
    }()

    func storeFile(from url: URL, progressHandler: FileLoaderProgressHandler? = nil, completion: ((Bool) -> Void)? = nil) {

        guard let destinationUrl = localUrl(from: url) else {
            completion?(false)
            return
        }

        if fileManager.fileExists(atPath: destinationUrl.path) {
            try? FileManager.default.removeItem(atPath: destinationUrl.path)
        }
        else {

            let operation = BlockOperation { [weak self] in
                guard let location = self?.urlSession.synchronousDownloadTask(with: url).location else {
                    completion?(false)
                    return
                }

                do{
                    try self?.fileManager.moveItem(at: location , to: destinationUrl)
                }
                catch {
                    completion?(false)
                }
            }

            queue.addOperation(operation)
        }
    }

    func localFileUrl(for url: URL) -> URL? {
        guard let localUrl = localUrl(from: url) else {
            return nil
        }

        guard fileManager.fileExists(atPath: localUrl.path) else {
            return nil
        }

        return localUrl
    }

    @discardableResult
    func deleteFile(for url: URL) -> Bool {
        guard let fileUrl = localUrl(from: url) else {
            return false
        }

        do {
            try fileManager.removeItem(at: fileUrl)
            return true
        }
        catch {
            return false
        }
    }

    private func localUrl(from url: URL) -> URL? {
        guard let documentsDirectoryURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        return documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }
}

private extension URLSession {
    func synchronousDownloadTask(with url: URL) -> (location: URL?, response: URLResponse?, error: Error?) {
        var location: URL?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = downloadTask(with: url) {
            location = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (location, response, error)
    }
}

extension AppFileLoader: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

    }


    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        guard let item = activeLoads.first(where: { $0.task == downloadTask }) else {
            return
        }

        item.progressHandler?.progress = Float(totalBytesExpectedToWrite) / Float(totalBytesWritten)
    }
}
