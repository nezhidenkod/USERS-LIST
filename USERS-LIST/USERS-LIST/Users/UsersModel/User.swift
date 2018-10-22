//
//  User.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

struct UsersResults: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    init(realmUser: RLMUser) {
        self.name = Name(first: realmUser.first, last: realmUser.last)
        self.email = realmUser.email
        self.phone = realmUser.phone
        self.picture = Picture(thumbnail: realmUser.thumbnail)
        
    }
}

struct Name: Codable {
    let first, last: String
    
    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}

struct Picture: Codable {
    let thumbnail: String
    
    init(thumbnail: String) {
        self.thumbnail = thumbnail
    }
}
