//
//  UsersTableViewCell.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class UsersTableViewCell: BaseTableViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.image = UIImage(named: "placeholder")
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    
    // MARK: - Overriden funcs
    override func configure(withModel model: Any) {
        guard let viewModel = model as? UsersCellViewModel else { return }
        
        self.firstNameLabel.text = viewModel.fullname
        self.phoneLabel.text = viewModel.phone
        // TODO: Load from Alamofire
        self.userImageView.image = UIImage(named: "placeholder")
    }
    
}
