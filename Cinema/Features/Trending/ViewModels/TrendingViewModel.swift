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
    
    private var apiService: APIService
    var dailyState = BehaviorRelay<State>(value: .loading)
    var weeklyState = BehaviorRelay<State>(value: .loading)
    
    let dailyTrending = PublishSubject<TrendingResult>()
    let WeeklyTrending = PublishSubject<TrendingResult>()

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
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
                switch period {
                case .daily:
                    self.dailyTrending.onNext(trending)
                    self.dailyState.accept(.success)
                    self.dailyTrending.onCompleted()
                case .weekly:
                    self.WeeklyTrending.onNext(trending)
                    self.weeklyState.accept(.success)
                    self.WeeklyTrending.onCompleted()
                }
            })
            .disposed(by: disposeBag)
    }

}
