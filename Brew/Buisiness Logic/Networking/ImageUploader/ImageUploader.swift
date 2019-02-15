//
//  ImageUploader.swift
//  Brew
//
//  Created by Andriy Vahniy on 2/15/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

protocol ImageUploadable {
	func upload(image: UIImage, url: String, token: String)
}

extension ImageUploadable {
	func upload(image: UIImage, url: String, token: String) {
		let uploader = ImageUploader()
		uploader.upload(image: image, to: url, token: token)
	}
}

final class ImageUploader {
	func upload(image: UIImage, to strinfURL: String, token: String) {
		guard let request = makeRequest(image: image, to: strinfURL, token: token) else { return }
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
		}
		
		task.resume()
	}
	
	private func makeRequest(image: UIImage, to stringUrl: String, token: String) -> URLRequest? {
		guard let url = URL(string: stringUrl) else { return nil }
		
		var request  = URLRequest(url: url)
		let boundary = "Boundary-\(UUID().uuidString)"
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		request.httpMethod = HTTPMethod.post.rawValue
		request.httpBody = createBody(boundary: boundary,
									  data: image.jpegData(compressionQuality: 0.7),
									  mimeType: "image/jpg",
									  filename: "user_profile.jpg")
		
		return request
	}
	
	private func createBody(parameters: [String: String]? = nil,
							boundary: String,
							data: Data?,
							mimeType: String,
							filename: String) -> Data? {
		guard let data = data else { return nil }
		
		var body = Data()
		let boundaryPrefix = "--\(boundary)\r\n"
		
		parameters?.forEach {
			body.append(boundaryPrefix)
			body.append("Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n")
			body.append("\($0.value)\r\n")
		}
		
		body.append(boundaryPrefix)
		body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
		body.append("Content-Type: \(mimeType)\r\n\r\n")
		body.append(data)
		body.append("\r\n")
		body.append("--".appending(boundary.appending("--")))
		
		return body
	}
}

private extension Data {
	mutating func append(_ string: String) {
		guard let data = string.data(using: .utf8) else { return }
		append(data)
	}
}

