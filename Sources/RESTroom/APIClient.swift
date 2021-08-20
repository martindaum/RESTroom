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
    let validator: ResponseValidator?
    let decoder: DataDecoder?
    let mapper: ErrorMapper?
    
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
    
    func request<T: DataRequest>(_ request: T, forEndpoint endpoint: Endpoint) -> T {
        return request
            .validate(validator: endpoint.validator ?? validator)
            .validate()
    }
}

extension APIClient {
    @discardableResult
    public func request(forEndpoint endpoint: Endpoint) -> EndpointRequest<DataRequest> {
        return EndpointRequest(endpoint: endpoint,
                               request: request(session.request(endpoint, interceptor: endpoint.interceptor), forEndpoint: endpoint),
                               mapper: endpoint.mapper ?? mapper,
                               decoder: decoder)
    }
    
    @discardableResult
    public func upload(data: Data, toEndpoint endpoint: Endpoint) -> EndpointRequest<UploadRequest> {
        return EndpointRequest(endpoint: endpoint,
                               request: request(session.upload(data, with: endpoint, interceptor: endpoint.interceptor), forEndpoint: endpoint),
                               mapper: endpoint.mapper ?? mapper,
                               decoder: decoder)
    }
    
    @discardableResult
    public func upload(file url: URL, toEndpoint endpoint: Endpoint) -> EndpointRequest<UploadRequest> {
        return EndpointRequest(endpoint: endpoint,
                               request: request(session.upload(url, with: endpoint, interceptor: endpoint.interceptor), forEndpoint: endpoint),
                               mapper: endpoint.mapper ?? mapper,
                               decoder: decoder)
    }
    
    @discardableResult
    public func multipartUpload(_ closure: @escaping (MultipartFormData) -> Void, toEndpoint endpoint: Endpoint) -> EndpointRequest<UploadRequest> {
        return EndpointRequest(endpoint: endpoint,
                               request: request(session.upload(multipartFormData: closure, with: endpoint, interceptor: endpoint.interceptor), forEndpoint: endpoint),
                               mapper: endpoint.mapper ?? mapper,
                               decoder: decoder)
    }
    
    @discardableResult
    public func download(fromEndpoint endpoint: Endpoint) -> EndpointRequest<DownloadRequest> {
        return EndpointRequest(endpoint: endpoint,
                               request: session.download(endpoint, interceptor: endpoint.interceptor),
                               mapper: endpoint.mapper ?? mapper,
                               decoder: decoder)
    }
}

extension EndpointRequest where T: DataRequest {
    @discardableResult
    public func response(completionHandler: @escaping (Result<Response<Void>, Error>) -> Void) -> EndpointRequest {
        let mapper = self.mapper
        let request = self.request.responseData(dataPreprocessor: endpoint.preprocessor) { response in
            completionHandler(response.voidResponse(withMapper: mapper))
        }
        return EndpointRequest(previous: self, request: request)
    }
    
    @discardableResult
    public func responseData(completionHandler: @escaping (Result<Response<Data>, Error>) -> Void) -> EndpointRequest {
        let mapper = self.mapper
        let request = self.request.responseData(dataPreprocessor: endpoint.preprocessor) { response in
            completionHandler(response.convertedResponse(withMapper: mapper))
        }
        return EndpointRequest(previous: self, request: request)
    }
    
    @discardableResult
    public func responseString(completionHandler: @escaping (Result<Response<String>, Error>) -> Void) -> EndpointRequest {
        let mapper = self.mapper
        let request = self.request.responseString(dataPreprocessor: endpoint.preprocessor) { response in
            completionHandler(response.convertedResponse(withMapper: mapper))
        }
        return EndpointRequest(previous: self, request: request)
    }
    
    @discardableResult
    public func responseJSON(completionHandler: @escaping (Result<Response<Any>, Error>) -> Void) -> EndpointRequest {
        let mapper = self.mapper
        let request = self.request.responseJSON(dataPreprocessor: endpoint.preprocessor) { response in
            completionHandler(response.convertedResponse(withMapper: mapper))
        }
        return EndpointRequest(previous: self, request: request)
    }
    
    @discardableResult
    public func responseDecodable<T: Decodable>(ofType type: T.Type, decoder: DataDecoder? = nil, completionHandler: @escaping (Result<Response<T>, Error>) -> Void) -> EndpointRequest {
        let decoder: DataDecoder = decoder ?? self.decoder ?? JSONDecoder()
        let mapper = self.mapper
        let request = self.request.responseDecodable(of: type, dataPreprocessor: endpoint.preprocessor, decoder: decoder) { response in
            completionHandler(response.convertedResponse(withMapper: mapper))
        }
        return EndpointRequest(previous: self, request: request)
    }
    
    @discardableResult
    public func responseSerialized<T: ResponseSerializer>(with serializer: T, completionHandler: @escaping (Result<Response<T.SerializedObject>, Error>) -> Void) -> EndpointRequest {
        let mapper = self.mapper
        let request = self.request.response(responseSerializer: serializer) { response in
            completionHandler(response.convertedResponse(withMapper: mapper))
        }
        return EndpointRequest(previous: self, request: request)
    }
}

extension EndpointRequest where T: UploadRequest {
    @discardableResult
    public func progress(closure: @escaping (Double) -> Void) -> EndpointRequest {
        let request = self.request.uploadProgress { progress in
            closure(progress.fractionCompleted)
        }
        return EndpointRequest(previous: self, request: request)
    }
}

extension EndpointRequest where T: DownloadRequest {
    @discardableResult
    public func progress(closure: @escaping (Double) -> Void) -> EndpointRequest {
        let request = self.request.downloadProgress { progress in
            closure(progress.fractionCompleted)
        }
        return EndpointRequest(previous: self, request: request)
    }
}
