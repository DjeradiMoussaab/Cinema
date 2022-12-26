//
//  TrendingEndpoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

enum TrendingEndpoint: Endpoint {
    case getDailyTrending
    case getWeeklyTrending
}

extension TrendingEndpoint {
    var httpMethod: RequestType {
        switch self {
        case .getDailyTrending:
            return .GET
        case .getWeeklyTrending:
            return .GET
        }
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var body: [String : String] {
        [:]
    }
    
    var parameters: [String : String] {
        ["api_key":APIConstants.accessToken]
    }
    
    var path: String {
        switch self {
        case .getDailyTrending:
            return APIConstants.dailyTrendingPath
        case .getWeeklyTrending:
            return APIConstants.weeklyTrendingPath
        }
    }
}
