//
//  FavoriteItemViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 16/2/2023.
//

import Foundation
import RxDataSources

typealias FavoriteItemSection = SectionModel<Int, FavoriteItemViewModel>

final class FavoriteItemViewModel {
    var title: String
    var rating: String
    var releaseDate: String
    var imagePath: String

    init(With item: MediaItem, mediaType: MediaType) {
        print(item)
        if mediaType == .movie {
            title = item.title ?? "No Title Available"
            releaseDate = item.releaseDate ?? "No Information Available"
        } else {
            title = item.name ?? "No Title Available"
            releaseDate = item.firstAirDate ?? "No Information Available"
        }
        rating = "\(item.voteAverage)"
        imagePath = item.posterPath
    }
    
}
