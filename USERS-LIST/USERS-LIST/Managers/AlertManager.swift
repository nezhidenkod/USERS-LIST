//
//  AlertManager.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class AlertManager {
    
    
    // MARK: - Private Properties
    private var rootViewController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window?.rootViewController
    }
    
    
    // MARK: - Public funcs
    func showAlertWith(title: String = "", message: String, onViewController: UIViewController?) {
        
        let alert: UIAlertController = createAlertWith(title: title, message: message)
        if onViewController != nil {
            onViewController?.present(alert, animated: true, completion: nil)
            return
        }
        rootViewController?.present(alert, animated: true, completion: nil)
        return
    }
    
    
    // MARK: - Private funcs
    private func createAlertWith(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelAction)
        return alert
    }
    
}
