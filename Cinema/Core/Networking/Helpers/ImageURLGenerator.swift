//
//  ImageURLGenerator.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 29/12/2022.
//

import Foundation


// MARK: - IMAGE URL Generator Protocol

protocol ImageURLGeneratorProtocol {
    func generateURL(with backdropPath: String) throws -> URL
}

// MARK: - IMAGE URL Generator
class ImageURLGenerator: ImageURLGeneratorProtocol {
    
    func generateURL(with backdropPath: String) throws -> URL {
        let urlString: String = APIConstants.scheme
            .appending(":")
            .appending(APIConstants.imageHost)
            .appending(APIConstants.imagePath)
            .appending(backdropPath)
        guard let url = URL(string: urlString) else { throw ErrorType.invalideURL }
        return url
    }

}
