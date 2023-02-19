//
//  FavoriteEndpoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 15/2/2023.
//

import Foundation

// MARK: - Favorite Endpoint Enumeration

enum FavoriteEndpoint: Endpoint {
    case getFavoriteTvShows(sessionID: String)
    case getFavotiteMovies(sessionID: String)
}

extension FavoriteEndpoint {
    var httpMethod: RequestType {
        return .GET
    }
    
    var parameters: [String : String] {
        ["api_key":APIConstants.accessToken,
         "session_id": Session.getSessionID()]
    }
    
    var path: String {
        switch self {
        case .getFavoriteTvShows:
            return APIConstants.favoriteTvShowsPath
        case .getFavotiteMovies:
            return APIConstants.favoriteMoviesPath
        }
    }
}


extension APIConstants {
    static let favoriteTvShowsPath = "/3/account/\(Session.getUser()?.id ?? 0)/favorite/tv"
    static let favoriteMoviesPath = "/3/account/\(Session.getUser()?.id ?? 0)/favorite/movies"
}
