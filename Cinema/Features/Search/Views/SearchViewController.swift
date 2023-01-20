//
//  SearchViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 17/1/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var searchViewModel: SearchViewModel!
    
    var tableView: UITableView!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SearchItemSection>(configureCell: { datasource, tableView, indexPath, item in
        print("idddd : \(SearchItemCell.reuseIdentifier)")
        
        let searchItemCell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.reuseIdentifier, for: indexPath) as! SearchItemCell
        self.searchViewModel.downloadImage(for: item)
            .bind(to: searchItemCell.searchImageView.rx.image)
            .disposed(by: self.disposeBag)
        searchItemCell.configure(with: item)
        return searchItemCell
    })
    
    let searchTextField : UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.placeholder = "SEARCHING..."
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10.0
        v.textAlignment = .center
        v.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    override func viewDidLoad() {
        self.searchViewModel = SearchViewModel(searchInput: searchTextField.rx.text.orEmpty.asDriver())
        setupViews()
        setupBinding()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        self.title = Tabs.search.rawValue
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: SearchItemCell.reuseIdentifier)
        
        
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    func setupBinding() {
        
        /// fetch Trending
        searchViewModel.fetchTrending(withTimePeriod: .daily, disposeBag)
        
        /// bind Table View to results based on Search Input after fetching is completed
        searchViewModel.getSearchResults(disposeBag: disposeBag)
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
}