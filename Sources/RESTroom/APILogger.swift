//
//  APILogger.swift
//  RESTroom
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import Alamofire

open class APILogger: EventMonitor {
    private let shouldLogDetails: Bool
    private let logClosure: (String) -> Void
    public let queue = DispatchQueue(label: NSUUID().uuidString)
    
    public init(shouldLogDetails: Bool = false, logClosure: ((String) -> Void)? = nil) {
        self.shouldLogDetails = shouldLogDetails
        self.logClosure = logClosure ?? { message in
            print(message)
        }
    }
    
    // Event called when any type of Request is resumed.
    open func requestDidResume(_ request: Request) {
        logClosure("⬆️ \(request.description)")
    }
    
    // Event called whenever a DataRequest has parsed a response.
    open func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        var icon = "✅"
        switch response.result {
        case .failure(_):
            icon = "🆘"
        default:
            break
        }
    
        logClosure("⬇️ \(icon) \(request.description)")
        if shouldLogDetails {
            logClosure(response.debugDescription)
        }
    }
}
