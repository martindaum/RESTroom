//
//  TestAPI.swift
//  RESTroomTests
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import RESTroom

struct TestAPI {
    static let baseURL: URL = URL(staticString: "https://jsonplaceholder.typicode.com")

    static func posts() -> Endpoint {
        return Endpoint(method: .get, url: baseURL.appending("posts"))
    }
    
    static func post(_ identifier: Int) -> Endpoint {
        return Endpoint(method: .get, url: baseURL.appending("posts/\(identifier)"))
    }
    
    static func validation() -> Endpoint {
        return Endpoint(method: .get, url: baseURL.appending("posts"), validator: TestValidator())
    }
}
