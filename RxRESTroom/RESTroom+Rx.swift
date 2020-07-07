//
//  RESTroom+Rx.swift
//  RxRESTroom
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import RxSwift
import RESTroom

extension APIClient {
    public func requestData(forEndpoint endpoint: Endpoint) -> Single<Response<Data>> {
        return Single.create { single in
            let request = self.requestData(forEndpoint: endpoint) { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func requestString(forEndpoint endpoint: Endpoint) -> Single<Response<String>> {
        return Single.create { single in
            let request = self.requestString(forEndpoint: endpoint) { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func requestJSON(forEndpoint endpoint: Endpoint) -> Single<Response<Any>> {
        return Single.create { single in
            let request = self.requestJSON(forEndpoint: endpoint) { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func requestDecodable<T: Decodable>(ofType type: T.Type, forEndpoint endpoint: Endpoint) -> Single<Response<T>> {
        return Single.create { single in
            let request = self.requestDecodable(ofType: type, forEndpoint: endpoint) { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
