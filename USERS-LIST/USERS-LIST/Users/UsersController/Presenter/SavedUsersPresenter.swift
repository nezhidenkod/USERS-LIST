//
//  SavedUsersPresenter.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation
import RealmSwift

class SavedUsersPresenter: UsersPresenterInput {
    
    
    // MARK: - Private Properties
    private let realm = try! Realm()
    private var items: Results<RLMUser>!
    private weak var output: UsersPresenterOutput!
    
    
    // MARK: - Initializers
    init(output: UsersPresenterOutput) {
        self.output = output
    }
    
    
    // MARK: - UsersPresenterInput
    func getData(forPage page: Int?) {
        items = realm.objects(RLMUser.self)
        let users: [User] = items.compactMap({ User(realmUser: $0) })
        output.reload(users: users)
    }
    
    func getUser(at index: Int) -> UserModel {
        return self.items[index]
    }
    
    func editUser(editCell: EditCell) {
        let index = editCell.indexPath.row
        let object = items[index]
        
        try! self.realm.write {
            self.realm.delete(object)
        }
        getData(forPage: nil)
    }
}
