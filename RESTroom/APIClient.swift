//
//  APIClient.swift
//  RESTroom
//
//  Created by Martin Daum on 28.05.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponeValidator {
    func validate(statusCode: Int, request: URLRequest?, response: HTTPURLResponse, data: Data?) throws
}

public final class APIClient {
    public let session: Session
    public let validator: ResponeValidator?
    
    public init(session: Session, validator: ResponeValidator? = nil) {
        self.session = session
        self.validator = validator
    }
    
    public convenience init(sessionConfiguration: URLSessionConfiguration = .default, interceptor: RequestInterceptor? = nil, validator: ResponeValidator? = nil, eventMonitors: [EventMonitor] = [], serverTrustManager: ServerTrustManager? = nil) {
        let sessionDelegate = SessionDelegate()
        let rootQueue = DispatchQueue(label: NSUUID().uuidString)
        let delegateQueue = OperationQueue()
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.underlyingQueue = rootQueue
        delegateQueue.name = NSUUID().uuidString
        
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: delegateQueue)
        let session = Session(session: urlSession, delegate: sessionDelegate, rootQueue: rootQueue, interceptor: interceptor, serverTrustManager: serverTrustManager, eventMonitors: eventMonitors)
        self.init(session: session, validator: validator)
    }
    
    public func validatedRequest(forEndpoint endpoint: Endpoint) -> DataRequest {
        return session.request(endpoint, interceptor: endpoint.interceptor)
            .validate(validator: endpoint.validator ?? validator)
    }
}

extension APIClient {
    @discardableResult
    public func requestData(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Data>, Error>) -> Void) -> DataRequest {
        return validatedRequest(forEndpoint: endpoint)
            .responseData { response in
                completionHandler(response.convertedResponse())
            }
    }
    
    @discardableResult
    public func requestString(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<String>, Error>) -> Void) -> DataRequest {
        return validatedRequest(forEndpoint: endpoint)
            .responseString { response in
                completionHandler(response.convertedResponse())
            }
    }
    
    @discardableResult
    public func requestJSON(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Any>, Error>) -> Void) -> DataRequest {
        return validatedRequest(forEndpoint: endpoint)
            .responseJSON { response in
                completionHandler(response.convertedResponse())
            }
    }
    
    @discardableResult
    public func requestDecodable<T: Decodable>(ofType type: T.Type, forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<T>, Error>) -> Void) -> DataRequest {
        return validatedRequest(forEndpoint: endpoint)
            .responseDecodable(of: type) { response in
                completionHandler(response.convertedResponse())
            }
    }
}

extension AFDataResponse {
    fileprivate func convertedResponse() -> Result<Response<Success>, Error> {
        switch result {
        case .success(let data):
            return .success(Response(data: data, request: request, response: response, metrics: metrics))
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension DataRequest {
    fileprivate func validate(validator: ResponeValidator?) -> Self {
        guard let validator = validator else {
            return validate()
        }
        
        return validate { request, response, data in
            do {
                try validator.validate(statusCode: response.statusCode, request: request, response: response, data: data)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
    }
}
