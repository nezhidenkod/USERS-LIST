//
//  EditUserViewController.swift
//  USERS-LIST
//
//  Created by Дмитрий on 23.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

protocol EditUserCellDelegate: ActionsDelegate {
    func update(viewModel: EditUserCellViewModel)
    func showAlert(error: String)
}

class EditUserViewController: BaseViewController {
    
    
    // MARK: Configuration
    enum EditUserConfiguration {
        case new(User)
        case saved(User)
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Public Properties
    var configuration: EditUserConfiguration!
    
    
    // MARK: Private Properties
    private var user: User!
    private lazy var tableControl: EditUserTableControl = {
        return EditUserTableControl(tableView: tableView)
    }()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: Action funcs
    @objc private func save() {
        
        let realm = RealmManager()
        switch configuration! {
        case .new:
            let object = RLMUser(user: user)
            realm.save(object: object)
        case .saved:
            if let object = realm.getObject(key: user.phone) {
                realm.edit(object: object)
            }
        }
        
        // TODO: Coordinator
        tabBarController?.selectedIndex = 1
        navigationController?.popViewController(animated: false)
    }
    
    
    // MARK: Private funcs
    private func settings() {
        
        // - Config
        switch configuration! {
        case .new(let user), .saved(let user):
            self.user = user
            tableControl.updateUI(user: user)
            tableView.reloadData()
        }
        tableControl.actionsDelegate = self
        
        // - View settings
        title = "Edit user profile"
        view.backgroundColor = UIColor.groupTableViewBackground
        
        // - Navigation settings
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        tabBarController?.tabBar.isHidden = true
        
        // - TableView settings
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    
}


// MARK: - EditUserCellDelegate
extension EditUserViewController: EditUserCellDelegate {
    
    func update(viewModel: EditUserCellViewModel) {
        switch viewModel.type {
        case .phone:
            self.user.phone = viewModel.value
        case .email:
            self.user.email = viewModel.value
        case .first:
            self.user.name.first = viewModel.value
        case .last:
            self.user.name.last = viewModel.value
        }
    }
    
    func showAlert(error: String) {
        let alert = AlertManager()
        alert.showAlertWith(message: error, onViewController: self)
    }
}
