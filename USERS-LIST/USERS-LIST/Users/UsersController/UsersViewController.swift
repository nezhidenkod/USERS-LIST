//
//  UsersViewController.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

// MARK: - PresenterInput
protocol UsersPresenterInput {
    func getData()
}

// MARK: - PresenterOutput
protocol UsersPresenterOutput: class {
    func reload(users: [User])
    func showError(_ error: String)
}

// MARK: - ViewController
class UsersViewController: BaseViewController {
    
    
    // MARK: Public Properties
    var presenter: UsersPresenterInput!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getData()
    }
    
}


// MARK: - UsersPresenterOutput
extension UsersViewController: UsersPresenterOutput {
    
    func reload(users: [User]) {
        print("USERS \(users.count)")
    }
    
    func showError(_ error: String) {
        let alert = AlertManager()
        alert.showAlertWith(message: error, onViewController: self)
    }
}
