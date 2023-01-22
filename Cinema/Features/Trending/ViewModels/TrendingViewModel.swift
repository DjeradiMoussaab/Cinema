//
//  TrendingViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class TrendingViewModel {
    
    private var apiClient: APIClientProtocol
    
    let trending = PublishSubject<[MediaItemSection]>()

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
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
            .compactMap({ TrendingResult in
                TrendingResult.results.compactMap { MediaItem in
                    return MediaItemViewModel(With: MediaItem)
                }
            })
            .map({ TrendingResult -> [MediaItemSection] in
                return [
                    MediaItemSection(
                        model: 0,
                        items: TrendingResult.filter { $0.mediaType == .tv }
                    ),
                    MediaItemSection(
                        model: 1,
                        items: TrendingResult.filter { $0.mediaType == .movie }
                    )
                ]
            })
            .subscribe(onNext: { trending  in
                self.trending.onNext(trending)
                self.trending.onCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    func downloadImage(for item: MediaItemSection.Item) -> Observable<UIImage> {
        do {
            return try apiClient.downloadImage(from: item.imagePath)
        } catch {
            return Observable.create { observer in
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }

}
