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
    
    private var editBarButton: UIBarButtonItem!
    
    var currentMediaType: MediaType = .movie

    
    private var dataSource : RxTableViewSectionedAnimatedDataSource<FavoriteItemSection>!
    
    /*private lazy var dataSource = RxTableViewSectionedReloadDataSource<FavoriteItemSection>(configureCell: { datasource, tableView, indexPath, item in
        let favoriteItemCell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemCell.reuseIdentifier, for: indexPath) as! FavoriteItemCell
        self.favoriteViewModel.downloadImage(for: item)
            .bind(to: favoriteItemCell.itemImageView.rx.image)
            .disposed(by: self.disposeBag)
        favoriteItemCell.configure(with: item)
        tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
        
        return favoriteItemCell
    })*/
    
    override func viewDidLoad() {
        self.favoriteViewModel = FavoriteViewModel()
        setupTableView()
        setupNavigationBar()
        setupBinding()
    }

    private func setupTableView() {
        setupTableViewLayout()
        registerCell()
        setupDataSource()
    }
    
    private func setupTableViewLayout() {
        view.backgroundColor = .systemGroupedBackground
        self.title = Tabs.favorite.rawValue
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 96
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func registerCell() {
        tableView.register(FavoriteItemCell.self, forCellReuseIdentifier: FavoriteItemCell.reuseIdentifier)
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<FavoriteItemSection>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .none,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .left),
            configureCell: configureCell,
            canEditRowAtIndexPath: canEditRowAtIndexPath
        )
    }
    
    private func setupNavigationBar() {
        editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [editBarButton]
    }
    
    func setupBinding() {
        bindDataSource()
        bindDeleted()
        bindSelected()
        bindNavigationBar()
    }
    
}



extension FavoriteViewController {
    
    func bindDataSource() {
        
        /// fetch Trending
        favoriteViewModel.fetchFavorite(withMediaType: currentMediaType, disposeBag)
        
        /// bind Table View to results based on Search Input after fetching is completed
        favoriteViewModel.favorites
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindDeleted() {
        tableView.rx.modelDeleted(FavoriteItemViewModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] favoriteItemViewModel in
                self.favoriteViewModel.remove(item: favoriteItemViewModel,mediaType: currentMediaType, disposeBag: disposeBag)
                print("$$$$$$ deleted \(favoriteItemViewModel.title)")

            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelected() {
        tableView.rx.modelSelected(FavoriteItemViewModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] item in
                print("$$$$$ selected \(item.title)")
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindNavigationBar() {
        editBarButton.rx.tap.asDriver()
            .map { [unowned self] in self.tableView.isEditing }
            .drive(onNext: { [unowned self] result in self.tableView.setEditing(!result, animated: true) })
            .disposed(by: disposeBag)
    }
}


extension FavoriteViewController {
    
    private var configureCell: RxTableViewSectionedAnimatedDataSource<FavoriteItemSection>.ConfigureCell {
        return { datasource, tableView, indexPath, item in
            let favoriteItemCell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemCell.reuseIdentifier, for: indexPath) as! FavoriteItemCell
            self.favoriteViewModel.downloadImage(for: item)
                .bind(to: favoriteItemCell.itemImageView.rx.image)
                .disposed(by: self.disposeBag)
            favoriteItemCell.configure(with: item)
            return favoriteItemCell
        }
    }

    private var canEditRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<FavoriteItemSection>.CanEditRowAtIndexPath {
        return { [unowned self] _, _ in
            if self.tableView.isEditing {
                return true
            } else {
                return false
            }
        }
    }

}
