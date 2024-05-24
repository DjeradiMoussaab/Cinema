//
//  FavoriteItemViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 16/2/2023.
//

import Foundation
import RxDataSources

typealias FavoriteItemSection = AnimatableSectionModel<Int, FavoriteItemViewModel>

final class FavoriteItemViewModel: IdentifiableType, Equatable {
    static func ==(lhs: FavoriteItemViewModel, rhs: FavoriteItemViewModel) -> Bool {
      return lhs.id == rhs.id
    }
    
    var id: Int
    typealias Identity = Int
    var identity: Identity {
        return id
      }
    
    var title: String
    var rating: String
    var releaseDate: String
    var imagePath: String

    init(With item: MediaItem, mediaType: MediaType) {
        print(item)
        id = item.id
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
