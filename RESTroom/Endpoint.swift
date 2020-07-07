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
    private let requestClosure: () throws -> URLRequest
    let validator: ResponeValidator?
    let interceptor: RequestInterceptor?
    
    public init(method: HTTPMethod, url: URL, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, validator: ResponeValidator? = nil, interceptor: RequestInterceptor? = nil) {
        requestClosure = {
            let request = try URLRequest(url: url, method: method, headers: headers)
            return try encoding.encode(request, with: parameters)
        }
        self.validator = validator
        self.interceptor = interceptor
    }
    
    public init<Parameters: Encodable>(method: HTTPMethod, url: URL, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, validator: ResponeValidator? = nil, interceptor: RequestInterceptor? = nil) {
        requestClosure = {
            let request = try URLRequest(url: url, method: method, headers: headers)
            return try parameters.map { try encoder.encode($0, into: request) } ?? request
        }
        self.validator = validator
        self.interceptor = interceptor
    }
}

extension Endpoint: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return try requestClosure()
    }
}
