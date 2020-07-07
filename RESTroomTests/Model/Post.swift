//
//  Post.swift
//  RESTroomTests
//
//  Created by Martin Daum on 07.07.20.
//  Copyright © 2020 Martindaum. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let identifier: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case identifier = "id"
        case title
        case body
    }
}
