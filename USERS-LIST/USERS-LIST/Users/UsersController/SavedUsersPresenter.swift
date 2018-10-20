//
//  SavedUsersPresenter.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

class SavedUsersPresenter: UsersPresenterInput {
    
    
    // MARK: - Private Properties
    private weak var output: UsersPresenterOutput!
    
    
    // MARK: - Initializers
    init(output: UsersPresenterOutput) {
        self.output = output
    }
    
    
    // MARK: - UsersPresenterInput
    func getData() {
        
        // TODO: Get user from storage
    }
    
}
