//
//  SearchViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 17/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    private var apiClient: APIClientProtocol

    
    let searchInput: Driver<String>
    let trending = BehaviorRelay<TrendingResult>(value: TrendingResult(page: 0, results: [], totalPages: 0, totalResults: 0))
    
    init(apiClient: APIClient = APIClient(), searchInput: Driver<String>) {
        self.apiClient = apiClient
        self.searchInput = searchInput
    }
    
    func fetchTrending(withTimePeriod period : TimePeriod,_ disposeBag: DisposeBag) {
        let endPoint: Endpoint = {
            switch period {
            case .daily:
                return TrendingEndpoint.getDailyTrending
            case .weekly:
                return TrendingEndpoint.getWeeklyTrending
            }
        }()
        apiClient.perform(endPoint)
            .map({ trending -> TrendingResult in
                return trending
            })
            .subscribe(onNext: { trending  in
                self.trending.accept(trending)
            })
            .disposed(by: disposeBag)
    }
    
    func getSearchResults(disposeBag: DisposeBag) -> Driver<[SearchItemSection]> {
        let trendingObservable = trending
            .compactMap({ TrendingResult -> [SearchItemViewModel] in
                return TrendingResult.results.compactMap { MediaItem in
                    return SearchItemViewModel(With: MediaItem)
                }
            })
            .asObservable()
        
        let searchInputObservable = searchInput
            .map({ String -> String in
                return String
            })
            .debounce(.milliseconds(200))
            //.skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        return Observable.combineLatest(trendingObservable, searchInputObservable)
            .map { (trendings, searchInput) in
                trendings.filter { SearchItemViewModel in
                    return SearchItemViewModel.title
                        .lowercased()
                        .hasPrefix(searchInput.lowercased())
                }
            }
            .map({ TrendingResult -> [SearchItemSection] in
                return [SearchItemSection (
                    model: 0,
                    items: TrendingResult
                )]
            })
            .map({ results -> [SearchItemSection] in
                return results
            })
            .asDriver(onErrorJustReturn: [])
    }

    func downloadImage(for item: SearchItemSection.Item) -> Observable<UIImage> {
        return apiClient
            .perform(ImageEndpoint
                .downloadImage(backdropPath: item.imagePath))
    }
    
}
