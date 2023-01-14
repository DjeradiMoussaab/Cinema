//
//  MediaItemViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 4/1/2023.
//

import Foundation
import RxDataSources


typealias MediaItemSection = SectionModel<Int, MediaItemViewModel>

final class MediaItemViewModel {
    var title: String
    var rating: String
    var releaseDate: String
    var imagePath: String
    var mediaType: MediaType

    init(With item: MediaItem) {
        print(item)
        if item.mediaType == .movie {
            title = item.title ?? "No Title Available"
            releaseDate = item.releaseDate ?? "No Information Available"
        } else {
            title = item.name ?? "No Title Available"
            releaseDate = item.firstAirDate ?? "No Information Available"
        }
        rating = "\(item.voteAverage)"
        imagePath = item.posterPath
        mediaType = item.mediaType
    }
    
}
