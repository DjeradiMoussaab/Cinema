//
//  ViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 26/12/2022.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var apiService: APIService?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiService = APIService(API(), JSONParser())
        do {
            self.apiService!.perform(TrendingEndpoint.getDailyTrending)
                .map({ (trendings: TrendingResult) in
                    print(trendings)
                })
                .subscribe()
                .disposed(by: disposeBag)
        } catch {
            
        }
        
    }
    
    
}

