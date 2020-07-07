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
    public let queue = DispatchQueue(label: NSUUID().uuidString)
    
    // Event called when any type of Request is resumed.
    open func requestDidResume(_ request: Request) {
        print("Resuming: \(request)")
    }
    
    // Event called whenever a DataRequest has parsed a response.
    open func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("Finished: \(response)")
    }
}
