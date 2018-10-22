//
//  SavedUsersTableControl.swift
//  USERS-LIST
//
//  Created by Дмитрий on 22.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

class SavedUsersTableControl: UsersTableControl {
    
    
    // MARK: - Public funcs
    override func setDataSource(_ dataSource: [User]) {
        
        // - Get CellModels
        var cells: [CellModel] = []
        for user in dataSource {
            
            let cellID = UsersTableViewCell.reuseID
            let viewModel = UsersCellViewModel(user: user)
            let cellModel = CellModel(viewModel: viewModel, cell: cellID, cellHeight: 71)
            cells.append(cellModel)
        }
        
        sections = [SectionModel(cellModels: cells)]
    }
    
}
