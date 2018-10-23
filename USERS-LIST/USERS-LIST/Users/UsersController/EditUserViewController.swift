//
//  EditUserViewController.swift
//  USERS-LIST
//
//  Created by Дмитрий on 23.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class EditUserViewController: BaseViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Public Properties
    var user: User!
    
    
    // MARK: Private Properties
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings()
    }
    
    
    // MARK: Action funcs
    @objc private func save() {
        // TODO: Save storage
        let realm = RealmManager()
        let object = RLMUser(user: user)
        realm.save(object: object)
        // TODO: Navigation
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
