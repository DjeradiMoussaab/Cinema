//
//  Endpoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

// MARK: - Endpoint Protocol

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: RequestType { get }
    var headers: [String: String] { get }
    var body: [String: String] { get }
    var parameters: [String: String] { get }
    
    func generateRequestURL() throws -> URLRequest
}

extension Endpoint {
    var scheme: String {
        return APIConstants.scheme
    }
    
    var host: String {
        return APIConstants.host
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var body: [String : String] {
        [:]
    }
    
    var parameters: [String : String] {
        [:]
    }
    
    func generateRequestURL() throws -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.setQueryItems(with: parameters)
        
        guard let url = urlComponents.url else { throw ErrorType.invalideURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HeaderType.contentType.rawValue)
        if !body.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        return urlRequest
    }
}

// MARK: - URLComponents Extension
    /// adding a methode that helps setting up the query items to the URLComponent item.
extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
