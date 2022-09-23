//
//  AFDataResponse+Error.swift
//  RESTroom
//
//  Created by Martin Daum on 08.02.21.
//  Copyright © 2021 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

extension DataResponse {
    func convertedResponse(withMapper mapper: ErrorMapper? = nil) -> Result<Response<Success>, Error> {
        switch result {
        case .success(let data):
            return .success(Response(data: data, request: request, response: response, metrics: metrics))
        case .failure(let error):
            return .failure(error.map(withMapper: mapper))
        }
    }
    
    func voidResponse(withMapper mapper: ErrorMapper? = nil) -> Result<Response<Void>, Error> {
        switch result {
        case .success:
            return .success(Response(data: (), request: request, response: response, metrics: metrics))
        case .failure(let error):
            var mappedError = error.asAFError?.underlyingError ?? error
            if let mapper = mapper {
                mappedError = mapper.mapError(mappedError)
            }
            return .failure(mappedError)
        }
    }
}

extension DownloadResponse {
    func convertedResponse(withMapper mapper: ErrorMapper? = nil) -> Result<Response<Success>, Error> {
        switch result {
        case .success(let data):
            return .success(Response(data: data, request: request, response: response, metrics: metrics))
        case .failure(let error):
            return .failure(error.map(withMapper: mapper))
        }
    }
    
    func voidResponse(withMapper mapper: ErrorMapper? = nil) -> Result<Response<Void>, Error> {
        switch result {
        case .success:
            return .success(Response(data: (), request: request, response: response, metrics: metrics))
        case .failure(let error):
            var mappedError = error.asAFError?.underlyingError ?? error
            if let mapper = mapper {
                mappedError = mapper.mapError(mappedError)
            }
            return .failure(mappedError)
        }
    }
}

