//
//  NetworkUsersManager.swift
//
//  Created by Nezhidenko Dmitriy on 4/16/18.
//  Copyright © 2018 Дмитрий. All rights reserved.
//

import UIKit

// MARK: - Manager object
class NetworkUsersManager: NetworkManager {
    typealias URLPaths = UsersURLPaths
    
    
    // MARK: - Private Properties
    private let network: Network = NetworkHelper()
    
    
    // MARK: - Requsts
    func getUsers(page: Int, handler: @escaping ResultHandler<[User]>) {
        
        let path: UsersURLPaths = .getUsers(page: page)
        let request = NetworkRequest(path, log: false)
        self.network.execute(request, parse: Users.self) { (result) in
            
            switch result {
            case .success(let users):
                handler(.success(users.results))
            case .customParse:
                // Handle error response model
                handler(.error("Need custom parse"))
            case .failure(let error):
                handler(.error(error.localizedDescription))
            }
        }
    }
    
}
