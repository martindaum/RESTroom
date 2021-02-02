//
//  APIClient+Upload.swift
//  RESTroom
//
//  Created by Martin Daum on 02.02.21.
//  Copyright © 2021 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

extension APIClient {
    func uploadRequest(_ request: UploadRequest, forEndpoint endpoint: Endpoint) -> UploadRequest {
        return request
            .validate()
            .validate(validator: endpoint.validator ?? validator)
    }
}

// MARK: Upload Data

extension APIClient {
    @discardableResult
    public func response(forUploadingData data: Data, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Void>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(data, to: endpoint), forEndpoint: endpoint)
            .responseData(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.voidResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseData(forUploadingData data: Data, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Data>, Error>) -> Void) -> DataRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(data, to: endpoint), forEndpoint: endpoint)
            .responseData(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseString(forUploadingData data: Data, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<String>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(data, to: endpoint), forEndpoint: endpoint)
            .responseString(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseJSON(forUploadingData data: Data, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Any>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(data, to: endpoint), forEndpoint: endpoint)
            .responseJSON(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseDecodable<T: Decodable>(ofType type: T.Type, forUploadingData data: Data, toEndpoint endpoint: Endpoint, decoder: DataDecoder? = nil, completionHandler: @escaping (Result<Response<T>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(data, to: endpoint), forEndpoint: endpoint)
            .responseDecodable(of: type, dataPreprocessor: endpoint.preprocessor, decoder: decoder ?? self.decoder ?? JSONDecoder()) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseSerialized<T: DataResponseSerializerProtocol>(forUploadingData data: Data, toEndpoint endpoint: Endpoint, serializedWith serializer: T, completionHandler: @escaping (Result<Response<T.SerializedObject>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(data, to: endpoint), forEndpoint: endpoint)
            .response(responseSerializer: serializer) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
}

// MARK: Upload Fileurl

extension APIClient {
    @discardableResult
    public func response(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Void>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(url, to: endpoint), forEndpoint: endpoint)
            .responseData(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.voidResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseData(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Data>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(url, to: endpoint), forEndpoint: endpoint)
            .responseData(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseString(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<String>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(url, to: endpoint), forEndpoint: endpoint)
            .responseString(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseJSON(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint, completionHandler: @escaping (Result<Response<Any>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(url, to: endpoint), forEndpoint: endpoint)
            .responseJSON(dataPreprocessor: endpoint.preprocessor) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseDecodable<T: Decodable>(ofType type: T.Type, forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint, decoder: DataDecoder? = nil, completionHandler: @escaping (Result<Response<T>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(url, to: endpoint), forEndpoint: endpoint)
            .responseDecodable(of: type, dataPreprocessor: endpoint.preprocessor, decoder: decoder ?? self.decoder ?? JSONDecoder()) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
    
    @discardableResult
    public func responseSerialized<T: DataResponseSerializerProtocol>(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint, serializedWith serializer: T, completionHandler: @escaping (Result<Response<T.SerializedObject>, Error>) -> Void) -> UploadRequest {
        let mapper = endpoint.mapper ?? self.mapper
        return uploadRequest(session.upload(url, to: endpoint), forEndpoint: endpoint)
            .response(responseSerializer: serializer) { response in
                completionHandler(response.convertedResponse(withMapper: mapper))
            }
    }
}
