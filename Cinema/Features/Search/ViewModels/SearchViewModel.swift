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
    
    private var apiService: APIService
    private var imageURLGenerator: ImageURLGenerator

    
    let searchInput: Driver<String>
    let trending = BehaviorRelay<TrendingResult>(value: TrendingResult(page: 0, results: [], totalPages: 0, totalResults: 0))
    
    init(apiService: APIService = APIService(), searchInput: Driver<String>) {
        self.apiService = apiService
        self.imageURLGenerator = ImageURLGenerator()
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
        apiService.perform(endPoint)
            .map({ trending -> TrendingResult in
                return trending
            })
            .subscribe(onNext: { trending  in
                print("got here resultsss 1")
                self.trending.accept(trending)
            })
            .disposed(by: disposeBag)
    }
    
    func getSearchResults(disposeBag: DisposeBag) -> Driver<[SearchItemSection]> {
        print("got here resultsss 3")
        let trendingObservable = trending
            .compactMap({ TrendingResult -> [SearchItemViewModel] in
                print("got here resultsss 2")
                return TrendingResult.results.compactMap { MediaItem in
                    return SearchItemViewModel(With: MediaItem)
                }
            })
            //.skip(1)
            .asObservable()
        
        let searchInputObservable = searchInput
            .map({ String -> String in
                print("got here resultsss 5")
                return String
            })
            .debounce(.milliseconds(200))
            .skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        return Observable.combineLatest(trendingObservable, searchInputObservable)
            .map { (trendings, searchInput) in
                trendings.filter { SearchItemViewModel in
                    print("resultsss 11 : \(trendings.count)")
                    return !searchInput.isEmpty &&
                    SearchItemViewModel.title
                        .lowercased()
                        .hasPrefix(searchInput.lowercased())
                }
            }
            .map({ TrendingResult -> [SearchItemSection] in
                print("got here resultsss 4 \(TrendingResult)")
                return [SearchItemSection (
                    model: 0,
                    items: TrendingResult
                )]
                
            })
            .map({ results -> [SearchItemSection] in
                print("resultsss : \(results)")
                return results
            })
            .asDriver(onErrorJustReturn: [])
    }

    func downloadImage(for item: SearchItemSection.Item) -> Observable<UIImage?> {
        do {
            let url = try imageURLGenerator.generateURL(with: item.imagePath)
            let urlRequest = URLRequest(url: url)
            return URLSession.shared.rx
                .data(request: urlRequest)
                .map { data in UIImage(data: data) }
        } catch {
            return Observable.create { observer in
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
    
}
