//
//  TestValidator.swift
//  RESTroomTests
//
//  Created by Martin Daum on 30.09.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import RESTroom
import Alamofire

final class TestValidator: ResponseValidator {
    func validate(statusCode: Int, request: URLRequest?, response: HTTPURLResponse, data: Data?) throws -> ResponseValidationResult {
        return .validated
    }
}
