//
//  AccountEndpoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 31/1/2023.
//

import Foundation

enum AccountEndpoint: Endpoint {
    case getAccountDetails(sessionID: String)
}

extension AccountEndpoint {
    var httpMethod: RequestType {
        return .GET
    }
    
    var body: [String : String] {
        return [:]
    }
    
    var parameters: [String : String] {
        switch self {
        case .getAccountDetails(let sessionID):
            return ["api_key":APIConstants.accessToken,
                    "session_id": sessionID]
        }
        
    }
    
    var path: String {
        return APIConstants.accountPath
    }
}

extension APIConstants {
    static let accountPath = "/3/account"
}
