//
//  RequestType.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

// MARK: - Request Type Enumeration

enum RequestType: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}


enum MIMEType: String {
    case JSON = "application/json"
}

enum HeaderType: String {
    case contentType = "Content-Type"
}
