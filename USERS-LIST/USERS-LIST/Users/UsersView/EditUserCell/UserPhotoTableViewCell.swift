//
//  UserPhotoTableViewCell.swift
//  USERS-LIST
//
//  Created by Дмитрий on 23.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class UserPhotoTableViewCell: BaseTableViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
    }
    
    
    // MARK: - Overriden funcs
    override func configure(withModel model: Any) {
        guard let imagePath = model as? String else { return }
        
        if let url = URL(string: imagePath) {
            photoImageView.af_setImage(withURL: url)
        }
    }
    
    
    // MARK: - Action funcs
    @IBAction func changePhoto(_ sender: UIButton) {
        // TODO: Image picker
    }
    
}
