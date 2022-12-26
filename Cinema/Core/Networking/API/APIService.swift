//
//  APIService.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

protocol APIService {
    func perform<T:Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct ProductService: APIService {
    
    private let api: APIProtocol
    private let jsonParser: JSONParserProtocol
    
    init(_ api: APIProtocol = API(),_ jsonParser: JSONParserProtocol = JSONParser()) {
        self.api = api
        self.jsonParser = jsonParser
    }
    /// func that serves the api call, returning a decoded Data with generic type T
    func perform<T:Decodable>(_ endpoint: Endpoint) async throws -> T {
        let response = try await api.makeRequest(endpoint)
        let decodedResponse: T = try self.jsonParser.decode(response)
        return decodedResponse
    }

}

