//
//  RLMUser.swift
//  USERS-LIST
//
//  Created by Дмитрий on 22.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation
import RealmSwift

class RLMUser: Object {
    @objc dynamic var first: String = ""
    @objc dynamic var last: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var thumbnail: String = ""
    @objc dynamic var image: String = ""
    
    override class func primaryKey() -> String? {
        return "phone"
    }
}

extension RLMUser {
    
    convenience init(user: User) {
        self.init()
        self.first = user.name.first
        self.last = user.name.last
        self.email = user.email
        self.phone = user.phone
        self.thumbnail = user.picture.thumbnail
        self.image = user.picture.large
    }
}
