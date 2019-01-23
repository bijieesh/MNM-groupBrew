//
//  Networking.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/18/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import Foundation

class NetworkingStack {
    private(set) static var instance = NetworkingStack()

    let requestExecuter: RequestExecuter

    static func reconfigure(with token: Token? = nil) {
        instance = NetworkingStack(token: token)
    }

    private init(token: Token? = nil) {
        let session = URLSession.shared
        let requestFactory = DefaultRequestFactory(baseUrl: "https://cast.brew.com/api/")
        let dispatcher = URLSessionNetworkDispatcher(requestFactory: requestFactory, session: session)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        requestExecuter = DefaultRequestExecuter(dispatcher: dispatcher, decoder: jsonDecoder)
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

protocol ServerError: Codable {
    var message: String { get }
}

protocol RequestType: RequestData {
    associatedtype ResponseObjectType: Codable
    associatedtype ErrorType: ServerError
}

protocol NetworkDispatcher {
    func dispatch(_ request: RequestData, onSuccess: @escaping (Data, Int) -> Void, onError: @escaping (Error) -> Void)
}

protocol RequestFactory {
    func request(from requestData: RequestData) throws -> URLRequest
}

protocol RequestExecuter {
    func execute<T: RequestType>(_ request: T, onSuccess: ((T.ResponseObjectType) -> Void)?, onError: ((NetworkingError<T.ErrorType>) -> Void)?, responseQueue: DispatchQueue)
}

enum Token {
    case bearer(token: String)
    case jwt(token: String)
    case custom(token: String)

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

    var localizedDescription: String {
        switch self {
        case .invalidUrl: return "URL is invalid"
        case .noDataInResponse: return "No datain response"
        case .invalidResponse: return "Response is invalid"
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

extension RequestData {
    var queryParams: [(String, String)] { return [] }
    var bodyParams: [(String, Any)] { return [] }
    var headers: [String: String] { return [:] }
}

extension RequestType {
    typealias ResponseSuccessCallback = (ResponseObjectType) -> Void
    typealias ErrorCallback = (NetworkingError<ErrorType>) -> Void

    var data: RequestData {
        return DefaultRequestData(path: path, method: method, queryParams: queryParams, bodyParams: bodyParams, headers: headers)
    }

    func execute(onSuccess: ResponseSuccessCallback? = nil, onError: ErrorCallback? = nil, responseQueue: DispatchQueue = .main) {
        NetworkingStack.instance.requestExecuter.execute(self, onSuccess: onSuccess, onError: onError, responseQueue: responseQueue)
    }
}

struct DefaultRequestExecuter: RequestExecuter {
    private let jsonDecoder: JSONDecoder
    private let dispatcher: NetworkDispatcher

    init(dispatcher: NetworkDispatcher, decoder: JSONDecoder = JSONDecoder()) {
        self.dispatcher = dispatcher
        self.jsonDecoder = decoder
    }

    func execute<T: RequestType>(_ request: T, onSuccess: ((T.ResponseObjectType) -> Void)? = nil, onError: ((NetworkingError<T.ErrorType>) -> Void)? = nil, responseQueue: DispatchQueue = .main) {
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
                                        responseQueue.async { onError?(.custom(error: result, statusCode: statusCode)) }
                                    }
                                }
                                catch {
                                    responseQueue.async { onError?(.system(error: error)) }
                                }
        },

                            onError: { error in
                                responseQueue.async { onError?(.system(error: error)) }
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

    var isUnauthorize: Bool {
        return code == 401
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
            throw NetworkingInternalError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestData.bodyParams, options: [])
        urlRequest.httpMethod = requestData.method.rawValue
        urlRequest.allHTTPHeaderFields = defaultHeaders + requestData.headers

        setEncoding(into: &urlRequest)

        return urlRequest
    }

    private func setEncoding(into request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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

