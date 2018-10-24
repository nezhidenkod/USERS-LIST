//
//  EditUserTableViewCell.swift
//  USERS-LIST
//
//  Created by Дмитрий on 23.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

// MARK: - ViewModel
struct EditUserCellViewModel {
    let type: EditUserCellType
    let title: String
    var value: String
    let validation: Validation
    
    init(type: EditUserCellType, value: String) {
        self.type = type
        self.value = value
        self.title = type.title
        self.validation = type.validation
    }
}

// MARK: - TableViewCell
class EditUserTableViewCell: BaseTableViewCell {
    
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    // MARK: Private Properties
    private var viewModel: EditUserCellViewModel!
    private var delegate: EditUserCellDelegate {
        return self.actionsDelegate as! EditUserCellDelegate
    }
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        selectionStyle = .none
    }
    
    override func configure(withModel model: Any) {
        guard let viewModel = model as? EditUserCellViewModel else { return }
        
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        textField.text = viewModel.value
    }
    
}

// MARK: - UITextFieldDelegate
extension EditUserTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let text = textField.text ?? ""
        if let error = viewModel.validation.isValid(text: text) {
            
            delegate.showAlert(error: error)
            return false
        }
        
        viewModel.value = text
        delegate.update(viewModel: viewModel)
        return true
    }
    
}
