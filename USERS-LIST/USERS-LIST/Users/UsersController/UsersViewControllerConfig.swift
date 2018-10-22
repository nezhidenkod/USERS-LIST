//
//  UsersViewControllerConfig.swift
//  USERS-LIST
//
//  Created by Дмитрий on 22.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

enum UsersViewControllerConfig {
    
    case users(UsersViewController)
    case saved(UsersViewController)
    
    var presenter: UsersPresenterInput {
        switch self {
        case .users(let controller):
            return UsersPresenter(output: controller)
        case .saved(let controller):
            return SavedUsersPresenter(output: controller)
        }
    }
    
    var tableControl: UsersTableControl {
        switch self {
        case .users(let controller):
            let pagination = TablePagination(itemsPerBatch: 10)
            let tableControl = UsersTableControl(tableView: controller.tableView)
            tableControl.pagination = pagination
            return tableControl
        case .saved(let controller):
            return SavedUsersTableControl(tableView: controller.tableView)
        }
    }
}
