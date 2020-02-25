//
//  UserData.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/25.
//  Copyright © 2020 wimes. All rights reserved.
//

import Foundation

struct UserData: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct PostUserData: Codable {
    let userId: String
    let id: Int?
    let title: String
    let body: String
    
    init(id: Int? = nil) {
        self.userId = "1"
        self.title = "Title"
        self.body = "Body"
        self.id = id
        
    }
    
    func toUserData() -> UserData {
        return UserData(userId: Int(userId) ?? 0, id: id ?? 0, title: title, body: body)
        
    }
    
}

struct PatchUserData: Decodable {
    let userId: String
    let id: String
    let title: String
    let body: String
    
    func toUserData() -> UserData {
        return UserData(userId: Int(userId) ?? 0, id: Int(id) ?? 0, title: title, body: body)
    }
}

