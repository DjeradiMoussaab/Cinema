//
//  RequestTokenEndpoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/1/2023.
//

import Foundation

// MARK: - Request Token Endpoint 

enum TokenEndpoint: Endpoint {
    case getNewRequestToken
    case validateTokenWith(username: String, password: String, requestToken: String)
}

extension TokenEndpoint {
    var httpMethod: RequestType {
        switch self {
        case .getNewRequestToken:
            return .GET
        case .validateTokenWith:
            return .POST
        }
    }
    
    var body: [String : String] {
        switch self {
        case .validateTokenWith(let username,
                                let password,
                                let requestToken):
            return ["username": username,
                    "password": password,
                    "request_token": requestToken]
        case .getNewRequestToken:
            return [:]
        }
    }
    
    var parameters: [String : String] {
        ["api_key":APIConstants.accessToken]
    }
    
    var path: String {
        switch self {
        case .validateTokenWith:
            return APIConstants.validateTokenPath
        case .getNewRequestToken:
            return APIConstants.requestTokenPath
        }
    }
}


extension APIConstants {
    static let requestTokenPath = "/3/authentication/token/new"
    static let validateTokenPath = "/3/authentication/token/validate_with_login"
}
