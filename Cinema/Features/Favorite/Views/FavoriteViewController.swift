//
//  FavoriteViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 8/2/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class FavoriteViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var favoriteViewModel: FavoriteViewModel!
    
    var tableView: UITableView!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<FavoriteItemSection>(configureCell: { datasource, tableView, indexPath, item in
        
        let favoriteItemCell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemCell.reuseIdentifier, for: indexPath) as! FavoriteItemCell
        self.favoriteViewModel.downloadImage(for: item)
            .bind(to: favoriteItemCell.itemImageView.rx.image)
            .disposed(by: self.disposeBag)
        favoriteItemCell.configure(with: item)
        return favoriteItemCell
    })
    
    override func viewDidLoad() {
        self.favoriteViewModel = FavoriteViewModel()
        setupViews()
        setupBinding()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemGroupedBackground
        self.title = Tabs.favorite.rawValue
        tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 96, bottom: 0, right: 0)
        tableView.register(FavoriteItemCell.self, forCellReuseIdentifier: FavoriteItemCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    func setupBinding() {
        
        /// fetch Trending
        favoriteViewModel.fetchFavorite(withMediaType: .movie, disposeBag)
        
        /// bind Table View to results based on Search Input after fetching is completed
        favoriteViewModel.favorites
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
}
