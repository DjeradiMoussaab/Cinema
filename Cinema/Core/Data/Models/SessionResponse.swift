//
//  Session.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 31/1/2023.
//

import Foundation

// MARK: - Session Response Model

struct SessionResponse: Codable {
    let success: Bool
    let sessionID, statusMessage: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
