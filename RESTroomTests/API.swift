//
//  API.swift
//  RESTroomTests
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import RESTroom

struct API {
    static let baseURL = URL(staticString: "Test")
    
    static func checkCode() -> Endpoint {
        return try Endpoint(method: .post, url: baseURL.appendingPathComponent("test"))
    }
}

final class TestAPI {
    let apiClient = APIClient()
    
    func checkCode() {
        apiClient.requestString(forEndpoint: API.checkCode()) { result in
            
        }
    }
}
