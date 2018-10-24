//
//  EditUserTableControl.swift
//  USERS-LIST
//
//  Created by Дмитрий on 24.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class EditUserTableControl: TableControl {
    
    
    // MARK: - Public funcs
    func updateUI(user: User) {
        
        let photoCell = CellModel(viewModel: user.picture.large, cell: UserPhotoTableViewCell.reuseID)
        
        let height: CGFloat = 50
        let cellID = EditUserTableViewCell.reuseID
        let firstNameViewModel = EditUserCellViewModel(type: .first, value: user.name.first)
        let firstNameCell = CellModel(viewModel: firstNameViewModel, cell: cellID, cellHeight: height)
        
        let lastNameViewModel = EditUserCellViewModel(type: .last, value: user.name.last)
        let lastNameCell = CellModel(viewModel: lastNameViewModel, cell: cellID, cellHeight: height)
        
        let emailViewModel = EditUserCellViewModel(type: .email, value: user.email)
        let emailCell = CellModel(viewModel: emailViewModel, cell: cellID, cellHeight: height)
        
        let phoneViewModel = EditUserCellViewModel(type: .phone, value: user.phone)
        let phoneCell = CellModel(viewModel: phoneViewModel, cell: cellID, cellHeight: height)
        
        let cells = [photoCell, firstNameCell, lastNameCell, emailCell, phoneCell]
        
        let section = SectionModel(cellModels: cells)
        sections = [section]
    }
    
}
