//
//  RESTroom+Rx.swift
//  RxRESTroom
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

#if !COCOAPODS
import RESTroom
#endif

extension EndpointRequest where T: DataRequest {
    public func response() -> Single<Response<Void>> {
        return Single.create { single in
            let request = self.response { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseJSON() -> Single<Response<Any>> {
        return Single.create { single in
            let request = self.responseJSON { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseData() -> Single<Response<Data>> {
        return Single.create { single in
            let request = self.responseData { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseString() -> Single<Response<String>> {
        return Single.create { single in
            let request = self.responseString { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseDecodable<T: Decodable>(ofType type: T.Type, decoder: Alamofire.DataDecoder = JSONDecoder()) -> Single<Response<T>> {
        return Single.create { single in
            let request = self.responseDecodable(ofType: type, decoder: decoder) { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseSerialized<T: ResponseSerializer>(with serializer: T) -> Single<Response<T.SerializedObject>> {
        return Single.create { single in
            let request = self.responseSerialized(with: serializer) { result in
                switch result {
                case .success(let object):
                    single(.success(object))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension EndpointRequest where T: UploadRequest {
    @discardableResult
    public func progress() -> Observable<Double> {
        return Observable.create { observable in
            let request = self.progress { progress in
                observable.onNext(progress)
                
                if progress >= 1 {
                    observable.onCompleted()
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension EndpointRequest where T: DownloadRequest {
    @discardableResult
    public func progress() -> Observable<Double> {
        return Observable.create { observable in
            let request = self.progress { progress in
                observable.onNext(progress)
                
                if progress >= 1 {
                    observable.onCompleted()
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
