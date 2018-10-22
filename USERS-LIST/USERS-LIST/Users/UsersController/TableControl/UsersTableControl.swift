//
//  UsersTableControl.swift
//  USERS-LIST
//
//  Created by Дмитрий on 21.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class UsersTableControl: TableControl, UsersTableControlProtocol {
    
    
    // MARK: - Public funcs
    func setDataSource(_ dataSource: [User]) {
        
        // - Get CellModels
        var cells: [CellModel] = []
        for user in dataSource {
            
            let cellID = UsersTableViewCell.reuseID
            let viewModel = UsersCellViewModel(user: user)
            let cellModel = CellModel(viewModel: viewModel, cell: cellID, cellHeight: 71)
            cells.append(cellModel)
        }
        
        // - Add new cells
        if sections.isEmpty {
            let section = SectionModel(cellModels: cells)
            sections = [section]
        } else {
            sections[0].cellModels.append(contentsOf: cells)
        }
        
    }
    
}
