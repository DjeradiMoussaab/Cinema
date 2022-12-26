//
//  JSONParser.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

protocol JSONParserProtocol {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

class JSONParser: JSONParserProtocol {
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        guard let decodedData = try? jsonDecoder.decode(T.self, from: data) else {        throw ErrorType.DecodingError }
        return decodedData
    }
}
