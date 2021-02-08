//
//  EndpointRequest.swift
//  RESTroom
//
//  Created by Martin Daum on 08.02.21.
//  Copyright © 2021 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

public final class EndpointRequest<T: Request> {
    public let endpoint: Endpoint
    public let request: T
    public let mapper: ErrorMapper?
    
    init(endpoint: Endpoint, request: T, mapper: ErrorMapper? = nil) {
        self.endpoint = endpoint
        self.request = request
        self.mapper = mapper
    }
    
    init(previous: EndpointRequest<T>, request: T) {
        self.endpoint = previous.endpoint
        self.request = request
        self.mapper = previous.mapper
    }
    
    public var id: UUID {
        return request.id
    }
    
    @discardableResult
    public func cancel() -> T {
        return request.cancel()
    }
}

extension EndpointRequest: Equatable {
    public static func == (lhs: EndpointRequest<T>, rhs: EndpointRequest<T>) -> Bool {
        return lhs.id == rhs.id
    }
}
