//
//  APIService.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation
import RxSwift

protocol APIServiceProtocol {
    func perform<T:Decodable>(_ endpoint: Endpoint) -> Single<T>
}

struct APIService: APIServiceProtocol {
    
    private let api: APIProtocol
    private let jsonParser: JSONParserProtocol
    
    init(_ api: APIProtocol = API(),_ jsonParser: JSONParserProtocol = JSONParser()) {
        self.api = api
        self.jsonParser = jsonParser
    }
    /// func that serves the api call, returning a decoded Data with generic type T
    func perform<T:Decodable>(_ endpoint: Endpoint) -> Single<T> {
        
        return Single.create { (single) -> Disposable in
            
            let task = Task {
                do {
                    let response = try await api.makeRequest(endpoint)
                    let decodedResponse: T = try self.jsonParser.decode(response)
                    print(decodedResponse)
                    single(.success(decodedResponse))
                } catch {
                    //single(.error(ErrorType.unknown))
                }
            }
            return Disposables.create(with: {
                task.cancel()
            })
        }
    }
    
    /*func perform(_ endpoint: Endpoint) -> Single<TrendingResult> {
        
        return Single.create { (single) -> Disposable in
            
            let task = Task {
                do {
                    let response = try await api.makeRequest(endpoint)
                    let trendingResults: TrendingResult = try self.jsonParser.decode(response)
                    single(.success(trendingResults))
                } catch {
                    //single(.error(ErrorType.unknown))
                }
            }
            return Disposables.create(with: {
                task.cancel()
            })
        }
    }*/

}

