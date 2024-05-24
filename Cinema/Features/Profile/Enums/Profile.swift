//
//  Profile.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 6/2/2023.
//

import Foundation
import RxDataSources

struct ProfileItem {
    let label: String
    let icon: String
    
    init (label: String, icon: String) {
        self.label = label
        self.icon = icon
    }
}

typealias ProfileRowSection = SectionModel<Int, ProfileRows>

enum ProfileRows: CaseIterable {
    case header
    case details
    case favorite
    case settings
    case logout
    
    func infos() -> ProfileItem {
        switch self {
        case .header:
            return ProfileItem(label: "", icon: "")
        case .details:
            return ProfileItem(label: "Account Details", icon: "person")
        case .favorite:
            return ProfileItem(label: "Favorites", icon: "hand.thumbsup")
        case .settings:
            return ProfileItem(label: "Settings", icon: "house")
        case .logout:
            return ProfileItem(label: "Logout", icon: "rectangle.portrait.and.arrow.right")
        }
    }
}
