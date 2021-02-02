//
//  RESTroom+Rx.swift
//  RxRESTroom
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation
import RxSwift
#if !COCOAPODS
import RESTroom
#endif

extension APIClient {
    public func response(forEndpoint endpoint: Endpoint) -> Single<Response<Void>> {
        return Single.create { single in
            let request = self.response(forEndpoint: endpoint) { result in
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
    
    public func responseData(forEndpoint endpoint: Endpoint) -> Single<Response<Data>> {
        return Single.create { single in
            let request = self.responseData(forEndpoint: endpoint) { result in
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
    
    public func responseString(forEndpoint endpoint: Endpoint) -> Single<Response<String>> {
        return Single.create { single in
            let request = self.responseString(forEndpoint: endpoint) { result in
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
    
    public func responseJSON(forEndpoint endpoint: Endpoint) -> Single<Response<Any>> {
        return Single.create { single in
            let request = self.responseJSON(forEndpoint: endpoint) { result in
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
    
    public func responseDecodable<T: Decodable>(ofType type: T.Type, forEndpoint endpoint: Endpoint) -> Single<Response<T>> {
        return Single.create { single in
            let request = self.responseDecodable(ofType: type, forEndpoint: endpoint) { result in
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

// MARK: Upload Data

extension APIClient {
    public func response(forUploading data: Data, toEndpoint endpoint: Endpoint) -> Single<Response<Void>> {
        return Single.create { single in
            let request = self.response(forUploadingData: data, toEndpoint: endpoint) { result in
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
    
    public func responseData(forUploading data: Data, toEndpoint endpoint: Endpoint) -> Single<Response<Data>> {
        return Single.create { single in
            let request = self.responseData(forUploadingData: data, toEndpoint: endpoint) { result in
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
    
    public func responseString(forUploading data: Data, toEndpoint endpoint: Endpoint) -> Single<Response<String>> {
        return Single.create { single in
            let request = self.responseString(forUploadingData: data, toEndpoint: endpoint) { result in
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
    
    public func responseJSON(forUploading data: Data, toEndpoint endpoint: Endpoint) -> Single<Response<Any>> {
        return Single.create { single in
            let request = self.responseJSON(forUploadingData: data, toEndpoint: endpoint) { result in
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
    
    public func responseDecodable<T: Decodable>(ofType type: T.Type, forUploading data: Data, toEndpoint endpoint: Endpoint) -> Single<Response<T>> {
        return Single.create { single in
            let request = self.responseDecodable(ofType: type, forUploadingData: data, toEndpoint: endpoint) { result in
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

// MARK: Upload File URL

extension APIClient {
    public func response(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint) -> Single<Response<Void>> {
        return Single.create { single in
            let request = self.response(forUploadingFileAtUrl: url, toEndpoint: endpoint) { result in
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
    
    public func responseData(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint) -> Single<Response<Data>> {
        return Single.create { single in
            let request = self.responseData(forUploadingFileAtUrl: url, toEndpoint: endpoint) { result in
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
    
    public func responseString(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint) -> Single<Response<String>> {
        return Single.create { single in
            let request = self.responseString(forUploadingFileAtUrl: url, toEndpoint: endpoint) { result in
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
    
    public func responseJSON(forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint) -> Single<Response<Any>> {
        return Single.create { single in
            let request = self.responseJSON(forUploadingFileAtUrl: url, toEndpoint: endpoint) { result in
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
    
    public func responseDecodable<T: Decodable>(ofType type: T.Type, forUploadingFileAtUrl url: URL, toEndpoint endpoint: Endpoint) -> Single<Response<T>> {
        return Single.create { single in
            let request = self.responseDecodable(ofType: type, forUploadingFileAtUrl: url, toEndpoint: endpoint) { result in
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
