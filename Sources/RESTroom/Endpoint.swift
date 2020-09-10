//
//  Endpoint.swift
//  RESTroom
//
//  Created by Martin Daum on 02.03.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

public final class Endpoint {
    public let method: HTTPMethod
    public let url: URL
    private let requestClosure: () throws -> URLRequest
    let validator: ResponseValidator?
    let interceptor: RequestInterceptor?
    let preprocessor: DataPreprocessor
    
    public init(method: HTTPMethod, url: URL, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, validator: ResponseValidator? = nil, interceptor: RequestInterceptor? = nil, preprocessor: DataPreprocessor = PassthroughPreprocessor()) {
        self.method = method
        self.url = url
        self.validator = validator
        self.interceptor = interceptor
        self.preprocessor = preprocessor
        
        requestClosure = {
            let request = try URLRequest(url: url, method: method, headers: headers)
            return try encoding.encode(request, with: parameters)
        }
    }
    
    public init<Parameters: Encodable>(method: HTTPMethod, url: URL, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, validator: ResponseValidator? = nil, interceptor: RequestInterceptor? = nil, preprocessor: DataPreprocessor = PassthroughPreprocessor()) {
        self.method = method
        self.url = url
        self.validator = validator
        self.interceptor = interceptor
        self.preprocessor = preprocessor
        
        requestClosure = {
            let request = try URLRequest(url: url, method: method, headers: headers)
            return try parameters.map { try encoder.encode($0, into: request) } ?? request
        }
    }
}

extension Endpoint: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return try requestClosure()
    }
}
