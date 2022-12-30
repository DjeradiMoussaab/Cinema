//
//  TrendingViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation
import UIKit
import RxSwift

class TrendingViewController: UIViewController {
    
    private var trendingView: TrendingView!
    private var trendingViewModel = TrendingViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        setupViews()
        populateTrending(withTimePeriod: .daily)
        
        /// verifiying the state value changes flow before and after fetching data.
        trendingViewModel.dailyState
            .map({ state in
                switch state {
                case .loading:
                    print("it's loading")
                case .success:
                    print("it has succeded")
                case .failure:
                    print("it has failed")
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.backgroundColor = .blue
        trendingView = TrendingView()
        view.addSubview(trendingView)
        NSLayoutConstraint.activate([
            trendingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trendingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trendingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func populateTrending(withTimePeriod period: TimePeriod) {
        /// fetch Trending
        trendingViewModel.fetchTrending(withTimePeriod: period, disposeBag)
        
        /// use dailyTrending after fetching is completed
        trendingViewModel.dailyTrending
            .subscribe(onNext: { trending in
                print("total pagess: \(trending.totalPages)")
            })
            .disposed(by: disposeBag)
    }

}
