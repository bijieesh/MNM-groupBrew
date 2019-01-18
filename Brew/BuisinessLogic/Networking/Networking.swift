//
//  Networking.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class NetworkingStack {
    static let instance = NetworkingStack()

    let requestExecuter: RequestExecuter

    private init() {
        let session = URLSession.shared
        let requestFactory = DefaultRequestFactory(baseUrl: "https://cast.brew.com/api/")
        let dispatcher = URLSessionNetworkDispatcher(requestFactory: requestFactory, session: session)
        requestExecuter = DefaultRequestExecuter(dispatcher: dispatcher)
    }
}

protocol RequestData {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: [(String, String)] { get }
    var bodyParams: [String: Any] { get }
    var headers: [String: String] { get }
}

struct DefaultRequestData: RequestData {
    let path: String
    let method: HTTPMethod
    let queryParams: [(String, String)]
    let bodyParams: [String: Any]
    let headers: [String: String]
}

protocol CodableError: Codable, Error { }

protocol RequestType: RequestData {
    associatedtype ResponseObjectType: Codable
    associatedtype ErrorType: CodableError
}

protocol NetworkDispatcher {
    func dispatch(_ request: RequestData, onSuccess: @escaping (Data, Int) -> Void, onError: @escaping (Error) -> Void)
}

protocol RequestFactory {
    func request(from requestData: RequestData) throws -> URLRequest
}

protocol RequestExecuter {
    func execute<T: RequestType>(_ request: T, onSuccess: ((T.ResponseObjectType) -> Void)?, onError: ((ResponseError<T.ErrorType>) -> Void)?)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkingError: Error {
    case invalidUrl
    case noDataInResponse
    case invalidResponse

    var localizedDescription: String {
        switch self {
        case .invalidUrl: return "URL is invalid"
        case .noDataInResponse: return "No datain response"
        case .invalidResponse: return "Response is invalid"
        }
    }
}

enum ResponseError<T: CodableError> {
    case custom(error: T, statusCode: StatusCode)
    case system(error: Error)

    var message: String {
        switch self {
        case .system(let error): return error.localizedDescription
        case .custom(let error, _): return error.localizedDescription
        }
    }
}

extension RequestData {
    var queryParams: [(String, String)] { return [] }
    var bodyParams: [(String, Any)] { return [] }
    var headers: [String: String] { return [:] }
}

extension RequestType {
    typealias ResponseSuccessCallback = (ResponseObjectType) -> Void
    typealias ErrorCallback = (ResponseError<ErrorType>) -> Void

    var data: RequestData {
        return DefaultRequestData(path: path, method: method, queryParams: queryParams, bodyParams: bodyParams, headers: headers)
    }

    func execute(onSuccess: ResponseSuccessCallback? = nil, onError: ErrorCallback? = nil) {
        NetworkingStack.instance.requestExecuter.execute(self, onSuccess: onSuccess, onError: onError)
    }
}

struct DefaultRequestExecuter: RequestExecuter {
    let jsonDecoder = JSONDecoder()

    private let dispatcher: NetworkDispatcher

    init(dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }

    func execute<T: RequestType>(_ request: T, onSuccess: ((T.ResponseObjectType) -> Void)? = nil, onError: ((ResponseError<T.ErrorType>) -> Void)? = nil) {
        dispatcher.dispatch(request.data,

                            onSuccess: { (data, statusCode) in
                                let statusCode = StatusCode(statusCode)
                                let jsonDecoder = JSONDecoder()

                                do {
                                    if statusCode.isSuccessful {
                                        let result = try jsonDecoder.decode(T.ResponseObjectType.self, from: data)
                                        onSuccess?(result)
                                    }
                                    else {
                                        let result = try jsonDecoder.decode(T.ErrorType.self, from: data)
                                        onError?(.custom(error: result, statusCode: statusCode))
                                    }
                                }
                                catch {
                                    onError?(.system(error: error))
                                }
        },

                            onError: {
                                onError?(.system(error: $0))
        })
    }
}

struct StatusCode {
    static let unknown = StatusCode(-1)

    let code: Int

    init(_ code: Int) {
        self.code = code
    }

    var isSuccessful: Bool {
        return isIn(range: 200...299)
    }

    private func isIn(range: ClosedRange<Int>) -> Bool {
        return range.contains(code)
    }
}

struct DefaultRequestFactory: RequestFactory {

    private let baseUrl: String
    private let defaultHeaders: [String: String]

    init(baseUrl: String, defaultHeaders: [String: String] = [:]) {
        self.baseUrl = baseUrl
        self.defaultHeaders = defaultHeaders
    }

    func request(from requestData: RequestData) throws -> URLRequest {
        let urlString = baseUrl + requestData.path

        guard let url = URL(string: urlString)?.withAdded(requestData.queryParams) else {
            throw NetworkingError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestData.bodyParams, options: [])
        urlRequest.httpMethod = requestData.method.rawValue
        urlRequest.allHTTPHeaderFields = defaultHeaders + requestData.headers

        return urlRequest
    }
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    private let requestFactory: RequestFactory
    private let session: URLSession

    init(requestFactory: RequestFactory, session: URLSession = .shared) {
        self.requestFactory = requestFactory
        self.session = session
    }

    public func dispatch(_ requestData: RequestData, onSuccess: @escaping (Data, Int) -> Void, onError: @escaping (Error) -> Void) {
        do {
            let request = try requestFactory.request(from: requestData)

            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    onError(error)
                    return
                }

                guard let data = data else {
                    onError(NetworkingError.noDataInResponse)
                    return
                }

                if let httpUrlResponse = response as? HTTPURLResponse {
                    onSuccess(data, httpUrlResponse.statusCode)
                }
                else {
                    onError(NetworkingError.invalidResponse)
                }
            }

            task.resume()
        }
        catch {
            onError(error)
        }
    }
}



private func +<Key, Value>(left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
    var result = left

    for (key, value) in right {
        result[key] = value
    }

    return result
}

private extension URL {
    func withAdded(_ queryParams: [(key: String, value: String)]) -> URL {
        if var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            return urlComponents.url ?? self
        }
        else {
            return self
        }
    }
}

