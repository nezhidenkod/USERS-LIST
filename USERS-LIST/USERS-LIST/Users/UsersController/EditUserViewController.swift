//
//  EditUserViewController.swift
//  USERS-LIST
//
//  Created by Дмитрий on 23.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class EditUserViewController: BaseViewController {
    
    
    // MARK: Configuration
    enum EditUserConfiguration {
        case new(UserModel)
        case saved(UserModel)
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Public Properties
    var configuration: EditUserConfiguration!
    
    
    // MARK: Private Properties
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings()
    }
    
    
    // MARK: Action funcs
    @objc private func save() {
        
        let realm = RealmManager()
        switch configuration! {
        case .new(let user):
            let object = RLMUser(user: user)
            realm.save(object: object)
        case .saved(let user):
            let object = realm.getObject(key: user.phone)!
            realm.edit(object: object)
        }
        
        // TODO: Coordinator
        tabBarController?.selectedIndex = 1
        navigationController?.popViewController(animated: false)
    }
    
    
    // MARK: Private funcs
    private func settings() {
        title = "Edit user profile"
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }
    
}
