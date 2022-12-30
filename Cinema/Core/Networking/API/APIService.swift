//
//  APIService.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation
import RxSwift

// MARK: - API Serivce Protocol

protocol APIServiceProtocol {
    func perform<T:Decodable>(_ endpoint: Endpoint) -> Observable<T>
}

// MARK: - API Serivce 

struct APIService: APIServiceProtocol {
    
    private let api: APIProtocol
    private let jsonParser: JSONParserProtocol
    private let imageURLGenerator: ImageURLGeneratorProtocol

    init(_ api: APIProtocol = API(),_ jsonParser: JSONParserProtocol = JSONParser(),_ imageURLGenerator: ImageURLGeneratorProtocol = ImageURLGenerator()) {
        self.api = api
        self.jsonParser = jsonParser
        self.imageURLGenerator = imageURLGenerator
    }
    
    func perform<T:Decodable>(_ endpoint: Endpoint) -> Observable<T> {
        
        return Observable.just(endpoint)
            .flatMap { Endpoint -> Observable<Data> in
                return try api.makeRequest(endpoint)
            }
            .map { data -> T in
                let decodedResponse: T = try self.jsonParser.decode(data)
                return decodedResponse
            }
    }

}

