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

    private var authManager: AuthManager?
    private var baseUrl: String?

    private(set) var requestExecuter: RequestExecuter?

    private init() {}

    func update(authManager: AuthManager? = nil, baseUrl: String? = nil) {
        if let authManager = authManager {
            self.authManager = authManager
        }

        if let baseUrl = baseUrl {
            self.baseUrl = baseUrl
        }

        configure()
    }

    private func configure() {
        guard let dispatcher = networkDispatcher() else {
            return
        }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let requestExecuter = DefaultRequestExecuter(dispatcher: dispatcher, decoder: jsonDecoder)

        if let authManager = authManager {
            requestExecuter.requestRetries = [TokenRefreshRetrier(authManager: authManager)]
        }

        self.requestExecuter = requestExecuter

        authManager?.refreshToken(completion: nil)
    }

    private func networkDispatcher() -> NetworkDispatcher? {
        guard let baseUrl = baseUrl else {
            return nil
        }

        let requestFactory = DefaultRequestFactory(baseUrl: baseUrl, token: authManager?.authToken, encoding: .applicationJson)

        authManager?.onTokenUpdated = { newToken in
            requestFactory.updated(token: newToken, encoding: .applicationJson)
        }

        let session = URLSession.shared
        let dispatcher = URLSessionNetworkDispatcher(requestFactory: requestFactory, session: session)

        return dispatcher
    }
}

protocol RequestData {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: [(String, String)] { get }
    var bodyParams: [String: Any] { get }
    var headers: [NetworkingHeader] { get }
}

extension RequestData {
    var queryParams: [(String, String)] { return [] }
    var bodyParams: [String: Any] { return [:] }
    var headers: [NetworkingHeader] { return [] }
}

protocol AuthManager {
    var authToken: AuthToken? { get }

    var onTokenUpdated: ((_ newToken: AuthToken?) -> Void)? { get set }

    @discardableResult
    func refreshToken(completion: ((_ success: Bool) -> Void)?) -> Bool

    @discardableResult
    func logout(completion: ((_ success: Bool) -> Void)?) -> Bool
}

protocol ServerError: Codable {
    var message: String { get }
}

protocol NetworkingHeader {
    var key: String { get }
    var value: String { get }
}

protocol RequestType: RequestData {
    associatedtype ResponseObjectType: Codable
    associatedtype ErrorType: ServerError
}

extension RequestType {
    typealias ResponseSuccessCallback = (ResponseObjectType) -> Void
    typealias ErrorCallback = (NetworkingError<ErrorType>) -> Void

    var data: RequestData {
        return DefaultRequestData(path: path, method: method, queryParams: queryParams, bodyParams: bodyParams, headers: headers)
    }

    func execute(responseQueue: DispatchQueue = .main, onSuccess: ResponseSuccessCallback? = nil, onError: ErrorCallback? = nil) {
        guard let executer = NetworkingStack.instance.requestExecuter else {
            onError?(.system(error: NetworkingInternalError.stackNotInitialized))
            return
        }

        executer.execute(self, responseQueue: responseQueue, retryOnFail: true, onSuccess: onSuccess, onError: onError)
    }
}

protocol NetworkDispatcher {
    func dispatch(_ request: RequestData, onSuccess: @escaping (Data, Int) -> Void, onError: @escaping (Error) -> Void)
}

protocol RequestFactory {
    func request(from requestData: RequestData) throws -> URLRequest
}

protocol RequestRetrier {
    @discardableResult
    func handle<T: RequestType>(_ error: NetworkingError<T.ErrorType>, for request: T, completion: (_ newRequest: T) -> Void) -> Bool
}

protocol RequestExecuter {
    func execute<T: RequestType>(_ request: T, responseQueue: DispatchQueue, retryOnFail: Bool, onSuccess: ((T.ResponseObjectType) -> Void)?, onError: ((NetworkingError<T.ErrorType>) -> Void)?)
}

enum AuthToken: NetworkingHeader, Equatable {
    case bearer(token: String)
    case jwt(token: String)
    case custom(token: String)

    var key: String {
        return "Authorization"
    }

    var value: String {
        switch self {
        case .bearer(let token): return "Bearer \(token)"
        case .jwt(let token): return "JWT \(token)"
        case .custom(let token): return token
        }
    }

    var token: String {
        switch self {
        case .bearer(let token), .jwt(let token), .custom(let token): return token
        }
    }

    static func ==(left: AuthToken, right: AuthToken) -> Bool {
        return left.value == right.value
    }
}

enum ContentType: NetworkingHeader {
    case applicationJson
    case applicationXml
    case textHtml
    case imagePng
    case imageJpeg

    var key: String {
        return "Content-Type"
    }

    var value: String {
        switch self {
        case .applicationJson: return "application/json"
        case .applicationXml: return "application/json"
        case .textHtml: return "application/json"
        case .imagePng: return "application/json"
        case .imageJpeg: return "application/json"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkingInternalError: Error {
    case invalidUrl
    case noDataInResponse
    case invalidResponse
    case stackNotInitialized

    var localizedDescription: String {
        switch self {
        case .invalidUrl: return "URL is invalid"
        case .noDataInResponse: return "No datain response"
        case .invalidResponse: return "Response is invalid"
        case .stackNotInitialized: return "Networking stack is not initialized"
        }
    }
}

enum NetworkingError<T: ServerError> {
    case custom(error: T, statusCode: StatusCode)
    case system(error: Error)

    var message: String {
        switch self {
        case .system(let error): return error.localizedDescription
        case .custom(let error, _): return error.message
        }
    }
}

private class TokenRefreshRetrier: RequestRetrier {
    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    @discardableResult
    func handle<T>(_ error: NetworkingError<T.ErrorType>, for request: T, completion: (T) -> Void) -> Bool where T : RequestType {
        guard case .custom(_, let statusCode) = error, statusCode.isUnauthorize else {
            return false
        }


        return true
    }
}

private struct DefaultRequestData: RequestData {
    let path: String
    let method: HTTPMethod
    let queryParams: [(String, String)]
    let bodyParams: [String: Any]
    let headers: [NetworkingHeader]
}

private class DefaultRequestExecuter: RequestExecuter {
    var jsonDecoder: JSONDecoder
    var dispatcher: NetworkDispatcher

    var requestRetries: [RequestRetrier] = []

    init(dispatcher: NetworkDispatcher, decoder: JSONDecoder = JSONDecoder()) {
        self.dispatcher = dispatcher
        self.jsonDecoder = decoder
    }

    func execute<T: RequestType>(_ request: T, responseQueue: DispatchQueue = .main, retryOnFail: Bool = true, onSuccess: ((T.ResponseObjectType) -> Void)? = nil, onError: ((NetworkingError<T.ErrorType>) -> Void)? = nil) {
        dispatcher.dispatch(request.data,

                            onSuccess: { (data, statusCode) in
                                let statusCode = StatusCode(statusCode)
                                let jsonDecoder = JSONDecoder()

                                do {
                                    if statusCode.isSuccessful {
                                        let result = try jsonDecoder.decode(T.ResponseObjectType.self, from: data)
                                        responseQueue.async { onSuccess?(result)}
                                    }
                                    else {
                                        let result = try jsonDecoder.decode(T.ErrorType.self, from: data)
                                        let error: NetworkingError<T.ErrorType> = .custom(error: result, statusCode: statusCode)

                                        if retryOnFail {
                                            self.retry(with: error, for: request, responseQueue: responseQueue, onSuccess: onSuccess, onError: onError)
                                        }
                                        else {
                                            responseQueue.async { onError?(error) }
                                        }

                                    }
                                }
                                catch {
                                    responseQueue.async { onError?(.system(error: error)) }
                                }
        },

                            onError: {
                                let error: NetworkingError<T.ErrorType> = .system(error: $0)

                                if retryOnFail {
                                    self.retry(with: error, for: request, responseQueue: responseQueue, onSuccess: onSuccess, onError: onError)
                                }
                                else {
                                    responseQueue.async { onError?(error) }
                                }
        })
    }

    private func retry<T: RequestType>(with error: NetworkingError<T.ErrorType>, for request: T, responseQueue: DispatchQueue, onSuccess: ((T.ResponseObjectType) -> Void)? = nil, onError: ((NetworkingError<T.ErrorType>) -> Void)? = nil) {

        for retrier in requestRetries {
            let handled = retrier.handle(error, for: request) { newRequest in
                execute(newRequest, responseQueue: responseQueue, retryOnFail: false, onSuccess: onSuccess, onError: onError)
            }

            if handled {
                break
            }
        }
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

    var isUnauthorize: Bool {
        return code == 401
    }

    private func isIn(range: ClosedRange<Int>) -> Bool {
        return range.contains(code)
    }
}

private class DefaultRequestFactory: RequestFactory {

    private let baseUrl: String
    private var defaultHeaders: [NetworkingHeader]

    init(baseUrl: String, token: AuthToken? = nil, encoding: ContentType) {
        self.baseUrl = baseUrl
        let headers: [NetworkingHeader?] = [token, encoding]
        defaultHeaders = headers.compactMap({ $0 })
    }

    func request(from requestData: RequestData) throws -> URLRequest {
        let urlString = baseUrl + requestData.path

        guard let url = URL(string: urlString)?.withAdded(requestData.queryParams) else {
            throw NetworkingInternalError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestData.bodyParams, options: [])
        urlRequest.httpMethod = requestData.method.rawValue

        urlRequest.allHTTPHeaderFields = (defaultHeaders + requestData.headers).reduce([:]) {
            var copy = $0
            copy?[$1.key] = $1.value
            return copy
        }

        return urlRequest
    }

    func updated(token: AuthToken? = nil, encoding: ContentType) {
        let headers: [NetworkingHeader?] = [token, encoding]
        defaultHeaders = headers.compactMap({ $0 })
    }
}

class URLSessionNetworkDispatcher: NetworkDispatcher {
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
                    onError(NetworkingInternalError.noDataInResponse)
                    return
                }

                if let httpUrlResponse = response as? HTTPURLResponse {
                    onSuccess(data, httpUrlResponse.statusCode)
                }
                else {
                    onError(NetworkingInternalError.invalidResponse)
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
        if var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true), !queryParams.isEmpty {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            return urlComponents.url ?? self
        }
        else {
            return self
        }
    }
}

