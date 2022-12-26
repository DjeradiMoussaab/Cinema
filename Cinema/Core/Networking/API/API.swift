//
//  API.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

// MARK: - API Protocol

protocol APIProtocol {
    func makeRequest(_ endpoint: Endpoint) async throws -> Data
}

// MARK: - API

final class API: APIProtocol {
        
    func makeRequest(_ endpoint: Endpoint) async throws -> Data {
        let requestURL = try endpoint.generateRequestURL()
        let (data, response) = try await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorType.invalideResponse
        }
        return data
    }
    
}
