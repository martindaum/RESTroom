// swift-tools-version:5.0

//
//  Package.swift
//  RESTroom
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "RESTroom",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "RESTroom", targets: ["RESTroom"]),
        .library(name: "RxRESTroom", targets: ["RxRESTroom"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/WeTransfer/Mocker", .upToNextMajor(from: "2.0.0")), // dev
    ],
    targets: [
        .target(name: "RESTroom", dependencies: ["Alamofire"]),
        .target(name: "RxRESTroom", dependencies: ["RESTroom", "RxSwift"]),
        .testTarget(name: "RESTroomTests", dependencies: ["RESTroom", "RxRESTroom", "Mocker"]) // dev
    ]
)
