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
    
    var favorites = BehaviorRelay<[FavoriteItemSection]>(value: [])
    //let favorites = PublishSubject<[FavoriteItemSection]>()
    
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
                self.favorites.accept(favorites)
            })
            .disposed(by: disposeBag)
    }
    
    func downloadImage(for item: FavoriteItemSection.Item) -> Observable<UIImage> {
        return apiClient
            .perform(ImageEndpoint
                .downloadImage(backdropPath: item.imagePath))
    }
    
}



extension FavoriteViewModel {
    
    func remove(item : FavoriteItemViewModel, mediaType : MediaType) {
        
        let endPoint: Endpoint = {
            switch mediaType {
            case .tv:
                return FavoriteEndpoint.markTvShowAsFavorite(sesssionID: Session.getSessionID(), item: item, favorite: false)
            case .movie:
                return FavoriteEndpoint.markMovieAsFavorite(sesssionID: Session.getSessionID(), item: item, favorite: false)
            }
        }()
        
        apiClient.perform(endPoint)
            .map({ response -> SessionResponse in
                return response
            })
            .map({ SessionResponse in
                print("$$$$$$ \(SessionResponse.success)")
                print("$$$$$$ \(SessionResponse.statusMessage)")
            })
            .subscribe()
            .disposed(by: DisposeBag())
        
        
        let favorites = favorites.value
        Observable.of(favorites)
            .map { sections in
                sections[0].items.filter { FavoriteItemViewModel in
                    FavoriteItemViewModel.id != item.id
                }
            }
            .map({ favoriteResult -> [FavoriteItemSection] in
                return [FavoriteItemSection(
                    model: 0,
                    items: favoriteResult
                )]
            })
            .subscribe(onNext: { favorites  in
                self.favorites.accept(favorites)
            })
            .disposed(by: DisposeBag())
        
    }
}
