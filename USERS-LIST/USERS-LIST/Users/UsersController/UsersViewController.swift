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
    func getData(forPage page: Int?)
    func getUser(at index: Int) -> User
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
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Public Properties
    var configuration: UsersViewControllerConfig!
    
    
    // MARK: Private Properties
    private var presenter: UsersPresenterInput!
    private var tableControl: UsersTableControl!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings()
        presenter.getData(forPage: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getData(forPage: nil)
    }
    
    
    // MARK: Private funcs
    private func settings() {
        
        presenter = configuration.presenter
        tableControl = configuration.tableControl
        tableControl.didSelectCell.delegate(to: self) { (self, indexPath) in
            // TODO: Navigation
            let user = self.presenter.getUser(at: indexPath.row)
            let userDetail = EditUserViewController.fromStoryboard(.Users)
            userDetail.user = user
            self.navigationController?.pushViewController(userDetail, animated: true)
        }
        tableControl.pagination?.loadData.delegate(to: self) { (self, page) in
            self.presenter.getData(forPage: page)
        }
    }
    
}


// MARK: - UsersPresenterOutput
extension UsersViewController: UsersPresenterOutput {
    
    func reload(users: [User]) {
        tableControl.setDataSource(users)
        tableView.reloadData()
        tableControl.pagination?.update()
    }
    
    func showError(_ error: String) {
        let alert = AlertManager()
        alert.showAlertWith(message: error, onViewController: self)
    }
}
