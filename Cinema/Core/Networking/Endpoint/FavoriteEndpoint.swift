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
    case markMovieAsFavorite(sesssionID: String, item: FavoriteItemViewModel, favorite: Bool)
    case markTvShowAsFavorite(sesssionID: String, item: FavoriteItemViewModel, favorite: Bool)
}

extension FavoriteEndpoint {
    var httpMethod: RequestType {
        switch self {
        case .getFavoriteTvShows, .getFavotiteMovies:
            return .GET
        case .markMovieAsFavorite, .markTvShowAsFavorite:
            return .POST
        }
    }
    
    var body: [String : Any] {
        switch self {
        case .getFavoriteTvShows, .getFavotiteMovies:
            return [:]
        case .markMovieAsFavorite(_, let item, let favorite):
            return ["media_type": MediaType.movie.rawValue,
                    "media_id": item.id,
                    "favorite": favorite]
        case .markTvShowAsFavorite(_, let item, let favorite):
            return ["media_type": MediaType.tv.rawValue,
                    "media_id": item.id,
                    "favorite": favorite]
        }
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
        case .markMovieAsFavorite, .markTvShowAsFavorite:
            return APIConstants.markAsFavoritePath
        }
    }
}


extension APIConstants {
    static let favoriteTvShowsPath = "/3/account/\(Session.getUser()?.id ?? 0)/favorite/tv"
    static let favoriteMoviesPath = "/3/account/\(Session.getUser()?.id ?? 0)/favorite/movies"
    static let markAsFavoritePath = "/3/account/\(Session.getUser()?.id ?? 0)/favorite"
}
