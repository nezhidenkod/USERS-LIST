//
//  RealmManager.swift
//  USERS-LIST
//
//  Created by Дмитрий on 22.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    
    // MARK: - Private Properties
    private let realm = try! Realm()
    
    
    // MARK: - Public funcs
    func save(object: Object) {
        
        try! self.realm.write {
            self.realm.add(object)
        }
    }
    
    func edit(object: Object) {
        try! self.realm.write {
            self.realm.add(object, update: true)
        }
    }
    
    func remove(object: Object) {
        try! self.realm.write {
            self.realm.delete(object)
        }
    }
    
    func getObject(key: String) -> Object? {
        
        return realm.object(ofType: RLMUser.self, forPrimaryKey: key)
    }
    
}
