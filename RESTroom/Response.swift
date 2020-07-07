//
//  Response.swift
//  RESTroom
//
//  Created by Martin Daum on 02.03.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

public struct Response<T> {
    public let data: T
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let metrics: URLSessionTaskMetrics?
    
    public init(data: T, request: URLRequest? = nil, response: HTTPURLResponse? = nil,  metrics: URLSessionTaskMetrics? = nil) {
        self.data = data
        self.request = request
        self.response = response
        self.metrics = metrics
    }
    
    public var statusCode: Int? {
        return response?.statusCode
    }
}
