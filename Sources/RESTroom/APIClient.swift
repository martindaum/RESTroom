//
//  APIClient.swift
//  RESTroom
//
//  Created by Martin Daum on 28.05.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire



public final class APIClient {
    public let session: Session
    private let validator: ResponseValidator?
    private let decoder: DataDecoder?
    private let mapper: ErrorMapper?
    
    public init(session: Session, validator: ResponseValidator? = nil, decoder: DataDecoder? = nil, mapper: ErrorMapper? = nil) {
        self.session = session
        self.validator = validator
        self.decoder = decoder
        self.mapper = mapper
    }
    
    public convenience init(sessionConfiguration: URLSessionConfiguration = .default,
                            interceptor: RequestInterceptor? = nil,
                            validator: ResponseValidator? = nil,
                            eventMonitors: [EventMonitor] = [],
                            serverTrustManager: ServerTrustManager? = nil,
                            decoder: DataDecoder? = nil,
                            mapper: ErrorMapper? = nil) {
        let sessionDelegate = SessionDelegate()
        let rootQueue = DispatchQueue(label: NSUUID().uuidString)
        let delegateQueue = OperationQueue()
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.underlyingQueue = rootQueue
        delegateQueue.name = NSUUID().uuidString
        
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: delegateQueue)
        let session = Session(session: urlSession, delegate: sessionDelegate, rootQueue: rootQueue, interceptor: interceptor, serverTrustManager: serverTrustManager, eventMonitors: eventMonitors)
        self.init(session: session, validator: validator, decoder: decoder, mapper: mapper)
    }
    
    public func validatedRequest(forEndpoint endpoint: Endpoint) -> DataRequest {
        return session.request(endpoint, interceptor: endpoint.interceptor)
            .validate()
            .validate(validator: endpoint.validator ?? validator)
    }
}

extension APIClient {
    @discardableResult
    public func request(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Void>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return validatedRequest(forEndpoint: endpoint)
            .responseData(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.voidResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func requestData(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Data>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return validatedRequest(forEndpoint: endpoint)
            .responseData(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func requestString(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<String>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return validatedRequest(forEndpoint: endpoint)
            .responseString(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func requestJSON(forEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Any>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return validatedRequest(forEndpoint: endpoint)
            .responseJSON(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func requestDecodable<T: Decodable>(ofType type: T.Type, forEndpoint endpoint: Endpoint, decoder: DataDecoder? = nil, completionHandler: @escaping (Result<Response<T>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return validatedRequest(forEndpoint: endpoint)
            .responseDecodable(of: type, dataPreprocessor: endpoint.preprocessor, decoder: decoder ?? self.decoder ?? JSONDecoder()) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func requestSerialized<T: DataResponseSerializerProtocol>(with serializer: T, forEndpoint endpoint: Endpoint, decoder: DataDecoder? = nil, completionHandler: @escaping (Result<Response<T.SerializedObject>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return validatedRequest(forEndpoint: endpoint)
            .response(responseSerializer: serializer) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
}

extension AFDataResponse {
    fileprivate func convertedResponse(withMapper mapper: ErrorMapper? = nil) -> Result<Response<Success>, Error> {
        switch result {
        case .success(let data):
            return .success(Response(data: data, request: request, response: response, metrics: metrics))
        case .failure(let error):
            var mappedError = error.asAFError?.underlyingError ?? error
            if let mapper = mapper {
                mappedError = mapper.mapError(mappedError)
            }
            return .failure(mappedError)
        }
    }
    
    fileprivate func voidResponse(withMapper mapper: ErrorMapper? = nil) -> Result<Response<Void>, Error> {
        switch result {
        case .success:
            return .success(Response(data: (), request: request, response: response, metrics: metrics))
        case .failure(let error):
            var mappedError = error.asAFError?.underlyingError ?? error
            if let mapper = mapper {
                mappedError = mapper.mapError(mappedError)
            }
            return .failure(mappedError)
        }
    }
}

extension DataRequest {
    fileprivate func validate(validator: ResponseValidator?) -> Self {
        guard let validator = validator else {
            return self
        }

        return validate { request, response, data -> ValidationResult in
            do {
                try validator.validate(statusCode: response.statusCode, request: request, response: response, data: data)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
    }
}
