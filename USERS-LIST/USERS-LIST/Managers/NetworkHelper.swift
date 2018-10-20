//
//  NetworkHelper.swift
//
//  Created by Дмитрий on 13.04.2018.
//  Copyright © 2018 Дмитрий. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Typealias
typealias NetworkMethod = HTTPMethod
typealias ResultHandler<T> = (_ result: Result<T>) -> ()
typealias NetworkResultHandler<T> = (_ result: NetworkResult<T>) -> ()

// MARK: - Protocols
protocol NetworkManager {
    associatedtype URLPaths
}

protocol Network {
    
    func execute(url: String) -> NetworkResponse
    func execute(_ request: NetworkRequest, handler: @escaping (NetworkResultHandler<Data>))
    func execute<T>(_ request: NetworkRequest, parse entity: T.Type, handler: @escaping (NetworkResultHandler<T>)) where T: Decodable
    
    func parse<T>(_ response: NetworkResponse, entity: T.Type) -> NetworkResult<T> where T: Decodable
    func getResponse(for request: NetworkRequest, response: @escaping ((NetworkResponse) -> Void))
    func parseParameters<T>(entity: T) -> Parameters? where T: Codable
}

protocol URLPathProtocol {
    var baseURL: String { get }
    var url: String { get }
    var method: NetworkMethod { get }
    var response: ResponseType { get }
}


// MARK: - Network Headers
enum NetworkHeaders {
    
    case acceptType
    case contentType(ContentType)
    case authorization(token: String)
    case acceptEncoding
    
    // MARK: Content Type
    enum ContentType: String {
        case json = "application/json"
        case form = "application/x-www-form-urlencoded"
        case formData = "application/form-data"
        case binary = "application/binary"
    }
    
    // MARK: Keys
    var key: String {
        switch self {
        case .acceptType: return "Accept"
        case .contentType(_): return "Content-Type"
        case .authorization(_): return "Authorization"
        case .acceptEncoding: return "Accept-Encoding"
        }
    }
    
    // MARK: Values
    var value: String {
        switch self {
        case .contentType(let type):
            return type.rawValue
        case .authorization(let token):
            return token
        default: return ""
        }
    }
}


// MARK: Encoding
enum Encoding {
    case URL, JSON, String(String)
    var value: ParameterEncoding {
        switch self {
        case .URL: return URLEncoding.default
        case .JSON: return JSONEncoding.default
        case .String(let value): return value
        }
    }
}


// MARK: Response type
enum ResponseType {
    case JSON, String, Data
}

enum Result<T> {
    case success(T)
    case error(String)
}

// MARK: - NetworkResult object
enum NetworkResult<T> {
    
    // Parsing is successful, return "Entity"
    case success(T)
    
    // Parsing is failure. Return "Data" for custom parse
    case customParse(Data)
    
    // Return "Error"
    case failure(Error)
}


// MARK: - Request
struct NetworkRequest {
    
    
    // MARK: Public Properties
    let url: String
    let method: HTTPMethod
    let encoding: ParameterEncoding
    let response: ResponseType
    let headers: HTTPHeaders?
    var parameters: Parameters?
    let withHUD: Bool
    let log: Bool
    
    
    // MARK: Initializers
    init(_ path: URLPathProtocol, hud: Bool = true, log: Bool = false, encoding: Encoding = .JSON, parameters: [String : Any]? = nil, headers: [NetworkHeaders]? = nil) {
        self.url = path.url
        self.method = path.method
        self.response = path.response
        self.encoding = encoding.value
        self.parameters = parameters
        self.withHUD = hud
        self.log = log
        
        // - Set Headers
        guard let headers = headers else {
            self.headers = nil
            return
        }
        
        var result: HTTPHeaders = [:]
        for httpHeader in headers {
            result[httpHeader.key] = httpHeader.value
        }
        self.headers = result
    }
}


// MARK: - Response object
struct NetworkResponse {
    let data: Data?
    let error: Error?
    let statusCode: Int?
}


// MARK: - Network Helper
// - Execute requests
// - Parsing Decodable Entity
class NetworkHelper: Network {
    
    
    // MARK: Private properties
    private var manager: Alamofire.SessionManager
    
    
    // MARK: Initializers
    init() {
        manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
    }
    
    
    // MARK: Execute "Request" and Parse decodable "Entity"
    func execute<T>(_ request: NetworkRequest, parse entity: T.Type, handler: @escaping (NetworkResultHandler<T>)) where T: Decodable {
        // ... Hud show
        DispatchQueue.global().async {
            // Execute Request
            let response = self.execute(request)
            
            DispatchQueue.main.async {
                // ... Hud dismiss
                // Parse Response
                let parseResult = self.parse(response, entity: entity.self)
                handler(parseResult)
            }
        }
    }
    
    // MARK: Execute "Request" and return response "Data"
    func execute(_ request: NetworkRequest, handler: @escaping (NetworkResultHandler<Data>)) {
        // ... Hud show
        DispatchQueue.global().async {
            // Execute Request
            let response = self.execute(request)
            
            DispatchQueue.main.async {
                // ... Hud dismiss
                if let error = response.error {
                    handler(NetworkResult.failure(error))
                    return
                }
                if let data = response.data {
                    handler(NetworkResult.success(data))
                }
            }
        }
    }
    
    // MARK: Execute "URL"
    func execute(url: String) -> NetworkResponse {
        var data: Data?
        var error: Error?
        var code: Int?
        let group = DispatchGroup()
        group.enter()
        
        manager.request(url).responseJSON { (response) in
            data = response.data
            error = response.error
            code = response.response?.statusCode
            group.leave()
        }
        group.wait()
        return NetworkResponse(data: data, error: error, statusCode: code)
    }
    
    // MARK: Execute "Request" and return "Response"
    func getResponse(for request: NetworkRequest, response: @escaping ((NetworkResponse) -> Void)) {
        // ... Hud show
        DispatchQueue.global().async {
            // Execute Request
            let apiResponse = self.execute(request)
            
            DispatchQueue.main.async {
                // ... Hud dismiss
                response(apiResponse)
            }
        }
    }
    
    // MARK: Parse "Entity" and return "NetworkResult"
    func parse<T>(_ response: NetworkResponse, entity: T.Type) -> NetworkResult<T> where T: Decodable {
        
        // Return Error
        guard let data = response.data, response.error == nil else {
            return NetworkResult.failure(response.error!)
        }
        
        // Return Decoded Entity or Data for custom parse
        do {
            let object = try JSONDecoder().decode(entity, from: data)
            return NetworkResult.success(object)
            
        } catch let error {
            print(error)
            return NetworkResult.customParse(data)
        }
    }
    
    // MARK: Parse "Parameters" from codable "Entity"
    func parseParameters<T>(entity: T) -> Parameters? where T: Codable {
        
        var parameters: Parameters? = nil
        do {
            
            let jsonData = try JSONEncoder().encode(entity)
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
            parameters = dict as? Parameters
            
        } catch let error {
            print(error)
        }
        return parameters
    }
    
    
    // MARK: - Private funcs
    
    // MARK: Execute Request
    private func execute(_ request: NetworkRequest) -> NetworkResponse {
        let r: NetworkRequest = request
        var data: Data?
        var error: Error?
        var code: Int?
        let group = DispatchGroup()
        group.enter()
        
        switch r.response {
            
        // - Response Data
        case .Data:
            manager.request(r.url, method: r.method, parameters: r.parameters, encoding: r.encoding, headers: r.headers).responseData { (response) in
                
                if r.log {
                    print("RESPONSE (\(response.response?.statusCode ?? 0)): \(response)")
                }
                data = response.data
                error = response.error
                code = response.response?.statusCode
                group.leave()
            }
            group.wait()
            return NetworkResponse(data: data, error: error, statusCode: code)
        
        // - Response String
        case .String:
            manager.request(r.url, method: r.method, parameters: r.parameters, encoding: r.encoding, headers: r.headers).responseString { (response) in
                
                if r.log {
                    print("RESPONSE (\(response.response?.statusCode ?? 0)): \(response)")
                }
                data = response.data
                error = response.error
                code = response.response?.statusCode
                group.leave()
            }
            group.wait()
            return NetworkResponse(data: data, error: error, statusCode: code)
            
        // - Response JSON
        default:
            manager.request(r.url, method: r.method, parameters: r.parameters, encoding: r.encoding, headers: r.headers).responseJSON { (response) in
                
                if r.log {
                    print("RESPONSE (\(response.response?.statusCode ?? 0)): \(response)")
                }
                data = response.data
                error = response.error
                code = response.response?.statusCode
                group.leave()
            }
            group.wait()
            return NetworkResponse(data: data, error: error, statusCode: code)
        }
    }
}


// MARK: - ParameterEncoding for String
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

