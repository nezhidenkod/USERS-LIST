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
    func getData(forPage page: Int)
}

// MARK: - PresenterOutput
protocol UsersPresenterOutput: class {
    func reload(users: [User])
    func showError(_ error: String)
}

// MARK: - TableControl
protocol UsersTableControlProtocol {
    func setDataSource(_ dataSource: [User])
}

// MARK: - ViewController
class UsersViewController: BaseViewController {
    
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Public Properties
    var presenter: UsersPresenterInput!
    
    
    // MARK: Public Properties
    private var tableControl: UsersTableControlProtocol!
    private let pagination = TablePagination(itemsPerBatch: 10)
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView()
        presenter.getData(forPage: 1)
    }
    
    
    // MARK: Private funcs
    private func settingsTableView() {
        
        let usersTableControl = UsersTableControl(tableView: tableView)
        usersTableControl.pagination = pagination
        usersTableControl.didSelectCell.delegate(to: self) { (self, indexPath) in
            // TODO: Show Detail screen
        }
        pagination.loadData.delegate(to: self) { (self, page) in
            self.presenter.getData(forPage: page)
        }
        
        tableControl = usersTableControl
    }
    
}


// MARK: - UsersPresenterOutput
extension UsersViewController: UsersPresenterOutput {
    
    func reload(users: [User]) {
        tableControl.setDataSource(users)
        tableView.reloadData()
        pagination.update()
    }
    
    func showError(_ error: String) {
        let alert = AlertManager()
        alert.showAlertWith(message: error, onViewController: self)
    }
}
