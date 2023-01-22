//
//  APIService.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation
import RxSwift

// MARK: - API Serivce Protocol

protocol APIClientProtocol {
    func perform<T:Decodable>(_ endpoint: Endpoint) -> Observable<T>
    func downloadImage(from imagePath: String) throws -> Observable<UIImage>
}

// MARK: - API Serivce 

struct APIClient: APIClientProtocol {
    
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
    
    func downloadImage(from imagePath: String) throws -> Observable<UIImage> {
        do {
            let url = try imageURLGenerator.generateURL(with: imagePath)
            return try api.makeRequest(from: url)
                .map { data in UIImage(data: data)! }
        } catch {
            return Observable.create { observer in
                observer.onError(ErrorType.unknown)
                return Disposables.create()
            }
        }
    }

}

