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
    
    init(With item: MediaItem) {
        title = item.title ?? "No Title Available"
        rating = "\(item.voteAverage)"
        releaseDate = item.releaseDate ?? "No Information Available"
        imagePath = item.posterPath
    }
    
}
