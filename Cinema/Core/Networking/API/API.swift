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
    func makeRequest(from url: URL) async throws -> Data
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
    
    func makeRequest(from url: URL) async throws -> Data {
        if let imageData = cachedImages.object(forKey: url.absoluteString as NSString) {
            return imageData as Data
        }
        print("get error here pppp : \(url)")
        let (localUrl, _) = try await URLSession.shared.download(from: url)
        let data = try Data(contentsOf: localUrl)
        cachedImages.setObject(data as NSData, forKey: url.absoluteString as NSString)
        return data
    }
    
}
