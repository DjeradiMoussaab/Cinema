//
//  SessionEndpoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/1/2023.
//

import Foundation

// MARK: - Session Endpoint 

enum SessionEndpoint: Endpoint {
    case createSession(requestToken: String)
    case getAutorization(requestToken: String)
}

extension SessionEndpoint {
    var httpMethod: RequestType {
        switch self {
        case .createSession:
            return .POST
        case .getAutorization:
            return .GET
        }
    }

    var body: [String : Any] {
        switch self {
        case .createSession(let requestToken) :
            return ["request_token": requestToken]
        case .getAutorization:
            return [:]
        }
    }
    
    var parameters: [String : String] {
        ["api_key":APIConstants.accessToken]
    }
    
    var path: String {
        switch self {
        case .createSession:
            return APIConstants.createSessionPath
        case .getAutorization(let requestToken):
            return APIConstants.sessionLoginPath
                .appending("/\(requestToken)")
        }
    }
}

extension APIConstants {
    static let sessionLoginPath = "/3/authentication/token/validate_with_login"
    static let createSessionPath = "/3/authentication/session/new"
}
