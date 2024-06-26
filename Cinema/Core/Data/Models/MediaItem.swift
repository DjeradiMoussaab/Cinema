//
//  MediaItem.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import Foundation

// MARK: - TrendingResult
struct TrendingResult: Codable {
    let page: Int
    let results: [MediaItem]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MediaItem
struct MediaItem: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let title: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview, posterPath: String
    let mediaType: MediaType?
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let name, originalName, firstAirDate: String?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

// MARK: - MediaType
enum MediaType: String, Codable, CaseIterable {
    case movie = "movie"
    case tv = "tv"
}
