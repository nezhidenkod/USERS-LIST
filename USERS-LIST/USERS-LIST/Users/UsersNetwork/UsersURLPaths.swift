//
//  UsersURLPaths.swift
//  USERS-LIST
//
//  Created by Дмитрий on 20.10.2018.
//  Copyright © 2018 Dmitriy. All rights reserved.
//

import Foundation

// MARK: - Users URL Paths
enum UsersURLPaths: URLPathProtocol {
    
    // MARK: Base URL
    var baseURL: String {
        return Constants.baseURL
    }
    
    // MARK: Request paths
    case getUsers(page: Int)
    
    
    // MARK: URL for request
    var url: String {
        
        var path: String = ""
        switch self {
        case .getUsers(let page):
            path = "?page=\(page)&results=10"
        }
        return "\(baseURL)\(path)"
    }
    
    // MARK: HTTPMethod
    var method: NetworkMethod {
        switch self {
        default: return .get
        }
    }
    
    // MARK: Response Type
    var response: ResponseType {
        switch self {
        default: return .JSON
        }
    }
    
}
