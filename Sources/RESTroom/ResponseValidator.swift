//
//  ResponseValidator.swift
//  RESTroom
//
//  Created by Martin Daum on 30.09.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

public enum ResponseValidationResult {
    case validated
    case skipped
}

public protocol ResponseValidator {
    func validate(request: DataRequest) throws -> ResponseValidationResult
}
