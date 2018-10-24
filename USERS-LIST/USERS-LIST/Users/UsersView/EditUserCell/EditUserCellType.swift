//
//  EditUserCellType.swift
//  USERS-LIST
//
//  Created by Дмитрий on 24.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

protocol Validation {
    func isValid(text: String) -> String?
}

enum EditUserCellType {
    case first, last, email, phone
    
    var title: String {
        switch self {
        case .first:
            return "First name"
        case .last:
            return "Last name"
        case .email:
            return "Email"
        case .phone:
            return "Phone"
        }
    }
    
    var validation: Validation {
        switch self {
        case .email:
            return EmailValidation()
        default:
            return MainValidation()
        }
    }
}


struct MainValidation: Validation {
    
    func isValid(text: String) -> String? {
        
        if text.contains(" ") {
            return "Can't contain whitespaces"
        }
        
        switch text.count {
        case 0:
            return "Field can't be blank"
        case 30...:
            return "Validation: 1-30 characters"
        default:
            return nil
        }
    }
}

struct EmailValidation: Validation {
    
    func isValid(text: String) -> String? {
        // Valid email adress
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let error = email.evaluate(with: text) ? nil : "Please enter correct email."
        return error
    }
}
