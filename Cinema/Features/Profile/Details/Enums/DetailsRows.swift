//
//  DetailsRows.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 2/5/2023.
//

import Foundation
import RxDataSources

typealias ProfileDetailsSection = SectionModel<Int, ProfileDetailsRows>

enum ProfileDetailsRows: String, CaseIterable {
    case username = "Username"
    case name = "Name"
    case isAdult = "Include Adult"
    case language = "Language"
    case country = "Country"
}
