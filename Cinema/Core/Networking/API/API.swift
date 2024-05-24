//
//  API.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation
import RxSwift

// MARK: - API Protocol

protocol APIProtocol {
    func makeRequest(_ endpoint: Endpoint) throws -> Observable<Data>
}

// MARK: - API

final class API: APIProtocol {
    
    private let cachedImages = NSCache<NSString, NSData>()
    //wrapper
    
    func makeRequest(_ endpoint: Endpoint) throws -> Observable<Data> {
        let requestURL = try endpoint.generateRequestURL()
        let data = URLSession.shared.rx.data(request: requestURL)
        return data
    }
    
}
