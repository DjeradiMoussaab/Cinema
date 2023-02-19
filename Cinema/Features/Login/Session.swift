//
//  Session.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 24/1/2023.
//

import Foundation

enum UserKeys: String {
    case username = "username"
    case name = "name"
    case id = "id"
    case hash = "hash"
    case iso3166_1 = "iso3166_1"
    case iso639_1 = "iso639_1"
    case includeAdult = "includeAdult"
    
    case isUserConnected = "isUserConnected"
    case sessionID = "sessionID"
}

class Session {
    
    fileprivate static let defaults = UserDefaults.standard
    
    private var user: User!
    private var id: String!
    
    static func setSessionID(sessionID: String) {
        defaults.setValue(sessionID, forKey: UserKeys.sessionID.rawValue)
    }
    
    static func getSessionID() -> String {
        guard let sessionID = defaults.string(forKey: UserKeys.sessionID.rawValue) else { return "" }
        return sessionID
    }

    static func setUser(_ user: User) {
        defaults.setValue(user.username, forKey: UserKeys.username.rawValue)
        defaults.setValue(user.name, forKey: UserKeys.name.rawValue)
        defaults.setValue(user.id, forKey: UserKeys.id.rawValue)
        defaults.setValue(user.avatar.gravatar.hash, forKey: UserKeys.hash.rawValue)
        defaults.setValue(user.iso3166_1, forKey: UserKeys.iso3166_1.rawValue)
        defaults.setValue(user.iso639_1, forKey: UserKeys.iso639_1.rawValue)
        defaults.setValue(user.includeAdult, forKey: UserKeys.includeAdult.rawValue)
        
        defaults.setValue(true, forKey: UserKeys.isUserConnected.rawValue)
    }
    
    static func getUser() -> User? {
        
        if let hash = defaults.string(forKey: UserKeys.hash.rawValue),
           let iso639_1 = defaults.string(forKey: UserKeys.iso639_1.rawValue),
           let iso3166_1 = defaults.string(forKey: UserKeys.iso3166_1.rawValue),
           let name = defaults.string(forKey: UserKeys.name.rawValue),
           let username = defaults.string(forKey: UserKeys.username.rawValue)
        {
            let includeAdult = defaults.bool(forKey: UserKeys.includeAdult.rawValue)
            let id = defaults.integer(forKey: UserKeys.id.rawValue)
            
            let user = User(
                avatar: Avatar(gravatar: Gravatar(hash: hash)),
                id: id,
                iso639_1: iso639_1,
                iso3166_1: iso3166_1,
                name: name,
                includeAdult: includeAdult,
                username: username)
            return user
        }
        return nil
    }
    
    static func isUserConnected() -> Bool {
        return defaults.bool(forKey: UserKeys.isUserConnected.rawValue)
    }
    
    static func userDeconnected() {
        defaults.setValue(false, forKey: UserKeys.isUserConnected.rawValue)
    }
}
