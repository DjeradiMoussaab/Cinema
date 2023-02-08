//
//  Token.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 29/1/2023.
//

import Foundation

// MARK: - Request Token Model
struct Token: Codable {
    let success: Bool
    let expiresAt, requestToken, statusMessage: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
