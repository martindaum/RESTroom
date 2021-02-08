//
//  DataRequest+Extensions.swift
//  RESTroom
//
//  Created by Martin Daum on 08.02.21.
//  Copyright © 2021 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    func validate(validator: ResponseValidator?) -> Self {
        guard let validator = validator else {
            return self
        }

        return validate { request, response, data -> ValidationResult in
            do {
                try validator.validate(statusCode: response.statusCode, request: request, response: response, data: data)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
    }
}
