//
//  AppFileLoader.swift
//  Brew
//
//  Created by Vasyl Khmil on 2/2/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class AppFileLoader: NSObject {
    static let shared = AppFileLoader()

    private let queue = OperationQueue()

    func storeFile(from url: URL, progressHandler: AppFileLoaderProgressHandler? = nil, completion: ((Bool) -> Void)? = nil) {

        guard let destinationUrl = localUrl(from: url) else {
            completion?(false)
            return
        }

        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            try? FileManager.default.removeItem(atPath: destinationUrl.path)
        }
        else {

            let operation = AppFileLoaderOperation(url: url, localUrl: destinationUrl, progressHandler: progressHandler)

            operation.completionBlock = {
                completion?(true)
            }

            queue.addOperation(operation)
			
        }
    }
	
	func isLoading(_ url: URL) -> Bool {
		return operation(for: url) != nil
	}

    func setProgressHandler(_ handler: AppFileLoaderProgressHandler?, for url: URL) {
        guard let operation = operation(for: url) else {
            return
        }

        operation.progressHandler = handler
    }

    func cancelLoading(from url: URL) {
        guard let operation = operation(for: url) else {
            return
        }

        operation.cancel()
    }

    func localFileUrl(for url: URL) -> URL? {
		guard let localUrl = localUrl(from: url) else {
            return nil
        }

        guard FileManager.default.fileExists(atPath: localUrl.path) else {
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
            try FileManager.default.removeItem(at: fileUrl)
            return true
        }
        catch {
            return false
        }
    }

    private func localUrl(from url: URL) -> URL? {
        guard let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        return documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }

    private func operation(for url: URL) -> AppFileLoaderOperation? {
        return queue.operations.first(where: { ($0 as? AppFileLoaderOperation)?.url == url }) as? AppFileLoaderOperation
    }
}
