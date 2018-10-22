//
//  UsersTableViewCell.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit
import AlamofireImage

class UsersTableViewCell: BaseTableViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    // MARK: - Private properties
    private let placeholderImage = UIImage(named: "placeholder")
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.image = placeholderImage
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    
    // MARK: - Overriden funcs
    override func configure(withModel model: Any) {
        guard let viewModel = model as? UsersCellViewModel else { return }
        
        firstNameLabel.text = viewModel.fullname
        phoneLabel.text = viewModel.phone
        if let url = URL(string: viewModel.imagePath) {
            
            userImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
    }
    
}
