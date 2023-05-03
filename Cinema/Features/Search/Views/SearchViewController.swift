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
        let searchItemCell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.reuseIdentifier, for: indexPath) as! SearchItemCell

        // Bind the image to the cell when the download is complete
        self.searchViewModel.downloadImage(for: item)
            .observe(on: MainScheduler.instance) // Ensure UI updates are done on main thread
            .bind(to: searchItemCell.searchImageView.rx.image)
            .disposed(by: searchItemCell.disposeBag) // Use a dispose bag specific to the cell

        // Configure the cell with other data
        searchItemCell.configure(with: item)
        return searchItemCell
    })
    
    override func viewDidLoad() {
        
        let searchController = UISearchController()
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false // The default is true.
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // Make the search bar always visible.
        
        self.searchViewModel = SearchViewModel(searchInput: (navigationItem.searchController?.searchBar.rx.text.orEmpty.asDriver())!)
        setupViews()
        setupBinding()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemGroupedBackground
        self.title = Tabs.search.rawValue
        
        tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 96, bottom: 0, right: 0)
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: SearchItemCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
