//
//  RLMUser.swift
//  USERS-LIST
//
//  Created by Дмитрий on 22.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserModel {
    var first: String { get }
    var last: String { get }
    var email: String { get }
    var phone: String { get }
    var thumbnail: String { get }
}

class RLMUser: Object, UserModel {
    @objc dynamic var first: String = ""
    @objc dynamic var last: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var thumbnail: String = ""
    
    override class func primaryKey() -> String? {
        return "phone"
    }
}

extension RLMUser {
    
    convenience init(user: UserModel) {
        self.init()
        self.first = user.first
        self.last = user.last
        self.email = user.email
        self.phone = user.phone
        self.thumbnail = user.thumbnail
    }
}
