//
//  RESTroomTests.swift
//  RESTroomTests
//
//  Created by Martin Daum on 02.03.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import XCTest
@testable import RESTroom
import Mocker

final class RESTroomTests: XCTestCase {
    let apiClient = APIClient(eventMonitors: [APILogger()])
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPosts() {
        let expectation = XCTestExpectation()
        
        apiClient.requestDecodable(ofType: [Post].self, forEndpoint: TestAPI.posts()) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.data.count, 100)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Something went wrong")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSinglePost() {
        let expectation = XCTestExpectation()
        
        apiClient.requestDecodable(ofType: Post.self, forEndpoint: TestAPI.post(1)) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.data.identifier, 1)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Something went wrong")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidation() {
        let expectation = XCTestExpectation()
        
        apiClient.requestJSON(forEndpoint: TestAPI.validation()) { result in
            switch result {
            case .success(let response):
                print(response)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Something went wrong")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
