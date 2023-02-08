//
//  ImageEndPoint.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/1/2023.
//

import Foundation

// MARK: - Image Endpoint

enum ImageEndpoint: Endpoint {
    case downloadImage(backdropPath: String)
    case downloadAvatar(avatarHash: String)
}

extension ImageEndpoint {
    var httpMethod: RequestType {
        return .GET
    }
    
    var host: String {
        switch self {
        case .downloadImage:
            return APIConstants.imageHost
        case .downloadAvatar:
            return APIConstants.avatarHost
        }
    }
    
    var path: String {
        switch self {
        case .downloadImage(let backdropPath):
            return APIConstants.imagePath.appending(backdropPath)
        case .downloadAvatar(let avatarHash):
            return APIConstants.avatarPath.appending("/\(avatarHash)").appending(".jpg")
        }
    }
}

extension APIConstants {
    static let imagePath = "/t/p/original"
    static let imageHost = "image.tmdb.org"
    
    static let avatarPath = "/avatar"
    static let avatarHost = "secure.gravatar.com"
}

