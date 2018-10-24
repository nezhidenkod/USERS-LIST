//
//  UsersPresenter.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

class UsersPresenter: UsersPresenterInput {
    
    
    // MARK: - Private Properties
    private var users: [User] = []
    private weak var output: UsersPresenterOutput!
    
    
    // MARK: - Initializers
    init(output: UsersPresenterOutput) {
        self.output = output
    }
    
    
    // MARK: - UsersPresenterInput
    func getData(forPage page: Int?) {
        guard let nextPage = page else { return }
        
        let network = NetworkUsersManager()
        network.getUsers(page: nextPage) { [weak self] (result) in
            
            guard let `self` = self else { return }
            switch result {
            case .success(let users):
                if self.users.isEmpty {
                    self.users = users
                } else {
                    self.users.append(contentsOf: users)
                }
                self.output.reload(users: users)
            case .error(let error):
                self.output.showError(error)
            }
        }
    }
    
    func getUser(at index: Int) -> User {
        return self.users[index]
    }
    
    func editUser(editCell: EditCell) {
        
    }
}
