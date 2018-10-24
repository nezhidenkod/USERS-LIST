//
//  UsersCellViewModel.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

struct UsersCellViewModel {
    let fullname: String
    let imagePath: String
    let phone: String
    
    init(user: User) {
        let first = user.name.first.capitalized
        let last = user.name.last.capitalized
        self.fullname = "\(first) \(last)"
        self.imagePath = user.picture.thumbnail
        self.phone = user.phone
    }
}
