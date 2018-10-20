//
//  Coordinator.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import UIKit

typealias Navigation = UINavigationController

// MARK: - Storyboards name
enum StoryboardsName: String {
    case Users
}


// MARK: - Coordinator
class Coordinator {
    
    // MARK: App entry point
    class func start() -> UIWindow {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = UsersTabBarController()
        let navigation = Navigation(rootViewController: rootVC)
        navigation.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        return window
    }
    
    // MARK: Set Root ViewController in NavigationController
    class func setRootViewController(_ viewController: UIViewController) {
        let rootController = UIApplication.shared.keyWindow?.rootViewController as! Navigation
        rootController.setViewControllers([viewController], animated: false)
    }
    
}


// MARK: - Instantiate ViewController from Storyboards
protocol InstantiableFromStoryboard {
    static func fromStoryboard(_ name: StoryboardsName) -> Self
}

extension InstantiableFromStoryboard {
    
    static func fromStoryboard(_ name: StoryboardsName) -> Self {
        
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self {
            return viewController
        } else {
            fatalError("Cannot instantiate view controller of type " + identifier)
        }
    }
}

extension UIViewController: InstantiableFromStoryboard {}
