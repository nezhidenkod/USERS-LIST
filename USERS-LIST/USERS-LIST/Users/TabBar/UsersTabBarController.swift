//
//  UsersTabBarController.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

protocol TabControllersFactory {
    func getTabs() -> [UIViewController]
}

class UsersTabBarController: UITabBarController {
    
    
    // MAKR: - Factory
    var tabsFactory: TabControllersFactory = UsersTabsFactory()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - Set Tabs
        self.viewControllers = tabsFactory.getTabs()
    }
}
