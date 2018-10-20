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
    private weak var output: UsersPresenterOutput!
    
    
    // MARK: - Initializers
    init(output: UsersPresenterOutput) {
        self.output = output
    }
    
    
    // MARK: - UsersPresenterInput
    func getData() {
        
        let network = NetworkUsersManager()
        network.getUsers(page: 1) { [weak self] (result) in
            
            guard let `self` = self else { return }
            switch result {
            case .success(let users):
                self.output.reload(users: users)
            case .error(let error):
                self.output.showError(error)
            }
        }
    }
    
}
