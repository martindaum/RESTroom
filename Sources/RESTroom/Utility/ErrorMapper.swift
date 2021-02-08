//
//  ErrorMapper.swift
//  RESTroom
//
//  Created by Martin Daum on 30.09.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation

public protocol ErrorMapper {
    func mapError(_ error: Error) -> Error
}

extension Error {
    func map(withMapper mapper: ErrorMapper? = nil) -> Error {
        var mappedError = self.asAFError?.underlyingError ?? self
        if let mapper = mapper {
            mappedError = mapper.mapError(mappedError)
        }
        return mappedError
    }
}
