//
//  User.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 24/1/2023.
//

import Foundation

// MARK: - User
struct User: Codable {
    let avatar: Avatar
    let id: Int
    let iso639_1, iso3166_1, name: String
    let includeAdult: Bool
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case avatar, id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
    
    public static func Empty() -> User {
        return User(avatar: Avatar(gravatar: Gravatar(hash: "")),
                    id: 0,
                    iso639_1: "",
                    iso3166_1: "",
                    name: "",
                    includeAdult: false,
                    username: "")
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    let gravatar: Gravatar
}

// MARK: - Gravatar
struct Gravatar: Codable {
    let hash: String
}
