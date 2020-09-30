//
//  ResponseValidator.swift
//  RESTroom
//
//  Created by Martin Daum on 30.09.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponseValidator {
    func validate(statusCode: Int, request: URLRequest?, response: HTTPURLResponse, data: Data?) throws
}
