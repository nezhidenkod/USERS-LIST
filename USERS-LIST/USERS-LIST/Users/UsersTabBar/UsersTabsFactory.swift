//
//  UsersTabsFactory.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

class UsersTabsFactory {
    
    
    // MARK: - View Controllers
    enum ViewControllers: String {
        case users, saved
        
        // Title
        var title: String {
            switch self {
            case .users, .saved:
                return self.rawValue.capitalized
            }
        }
        
        // Image
        var image: String {
            switch self {
            case .users, .saved:
                return "tab_\(self.rawValue)"
            }
        }
        
    }
    
    
    // MARK: - Private funcs
    private func makeTab(_ viewController: ViewControllers) -> Navigation {
        
        let tab = UsersViewController.fromStoryboard(.Users)
        switch viewController {
        case .users:
            tab.presenter = UsersPresenter(output: tab)
        case .saved:
            tab.presenter = SavedUsersPresenter(output: tab)
        }
        
        let title = viewController.title
        let image = UIImage(named: viewController.image)
        let selectedImage = UIImage(named: "\(viewController.image)_active")
        
        tab.title = title
        tab.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        return Navigation(rootViewController: tab)
    }
    
}


// MARK: - TabControllersFactory
extension UsersTabsFactory: TabControllersFactory {
    
    func getTabs() -> [UIViewController] {
        
        let usersVC = makeTab(.users)
        let savedVC = makeTab(.saved)
        
        return [usersVC, savedVC]
    }
}
