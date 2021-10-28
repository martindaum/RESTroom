//
//  RESTroom+Combine.swift
//  RESTroom
//
//  Created by Martin Daum on 10.12.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//
//
//import Foundation
//import Alamofire
//#if canImport(Combine)
//import Combine
//
//@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
//public extension APIClient {
//    func publishData(forEndpoint endpoint: Endpoint) -> AnyPublisher<Response<Data>, Error> {
//        let mapper = endpoint.mapper ?? self.mapper
//        return request(forEndpoint: endpoint).request
//            .publishData(preprocessor: endpoint.preprocessor)
//            .convertResponse(withMapper: mapper)
//    }
//
//    func publishString(forEndpoint endpoint: Endpoint) -> AnyPublisher<Response<String>, Error> {
//        let mapper = endpoint.mapper ?? self.mapper
//        return request(forEndpoint: endpoint).request
//            .publishString(preprocessor: endpoint.preprocessor)
//            .convertResponse(withMapper: mapper)
//    }
//
//    func publishDecodable<Element: Decodable>(ofType type: Element.Type, forEndpoint endpoint: Endpoint, decoder: DataDecoder? = nil) -> AnyPublisher<Response<Element>, Error> {
//        let mapper = endpoint.mapper ?? self.mapper
//        let decoder = decoder ?? self.decoder ?? JSONDecoder()
//        return request(forEndpoint: endpoint).request
//            .publishDecodable(preprocessor: endpoint.preprocessor, decoder: decoder)
//            .convertResponse(withMapper: mapper)
//    }
//
//    func publishResponse<T: ResponseSerializer>(serializedWith serializer: T, forEndpoint endpoint: Endpoint) -> AnyPublisher<Response<T.SerializedObject>, Error> {
//        let mapper = endpoint.mapper ?? self.mapper
//        return request(forEndpoint: endpoint).request
//            .publishResponse(using: serializer)
//            .convertResponse(withMapper: mapper)
//    }
//}
//
//@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
//public extension AnyPublisher {
//    func value<Element: Any>() -> AnyPublisher<Element, Error> where Output == Response<Element>, Failure == Error {
//        map({ $0.data })
//            .eraseToAnyPublisher()
//    }
//}
//
//@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
//fileprivate extension DataResponsePublisher {
//    func convertResponse(withMapper mapper: ErrorMapper? = nil) -> AnyPublisher<Response<Value>, Error> {
//        tryMap { response in
//            switch response.result {
//            case .success(let data):
//                return Response(data: data, request: response.request, response: response.response, metrics: response.metrics)
//            case .failure(let error):
//                throw error.map(withMapper: mapper)
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}
//
//#endif
