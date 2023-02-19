//
//  FavoriteViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 8/2/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class FavoriteViewModel {
    
    private var apiClient: APIClientProtocol
    
    let favorites = PublishSubject<[FavoriteItemSection]>()
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchFavorite(withMediaType mediaType : MediaType,_ disposeBag: DisposeBag) {
        let endPoint: Endpoint = {
            switch mediaType {
            case .tv:
                return FavoriteEndpoint.getFavoriteTvShows(sessionID: Session.getSessionID())
            case .movie:
                return FavoriteEndpoint.getFavotiteMovies(sessionID: Session.getSessionID())
            }
        }()
        apiClient.perform(endPoint)
            .map({ favorites -> TrendingResult in
                return favorites
            })
            .compactMap({ TrendingResult in
                TrendingResult.results.compactMap { MediaItem in
                    return FavoriteItemViewModel(With: MediaItem, mediaType: mediaType)
                }
            })
            .map({ favoriteResult -> [FavoriteItemSection] in
                return [FavoriteItemSection(
                    model: 0,
                    items: favoriteResult
                )]
            })
            .subscribe(onNext: { favorites  in
                print("$$$$$ \(favorites)")
                self.favorites.onNext(favorites)
                self.favorites.onCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    func downloadImage(for item: FavoriteItemSection.Item) -> Observable<UIImage> {
        return apiClient
            .perform(ImageEndpoint
                .downloadImage(backdropPath: item.imagePath))
    }
    
}
