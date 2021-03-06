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
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
    init(realmUser: RLMUser) {
        self.name = Name(first: realmUser.first, last: realmUser.last)
        self.email = realmUser.email
        self.phone = realmUser.phone
        self.picture = Picture(thumbnail: realmUser.thumbnail, large: realmUser.image)
    }
}

struct Name: Codable {
    var first, last: String
    
    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}

struct Picture: Codable {
    var thumbnail, large: String
    
    init(thumbnail: String, large: String) {
        self.thumbnail = thumbnail
        self.large = large
    }
}
