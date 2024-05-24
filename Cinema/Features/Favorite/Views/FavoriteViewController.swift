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
    
    private var mediaTypeSelector: UISegmentedControl!
    
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
        
        mediaTypeSelector = UISegmentedControl(items: ["Movies", "TV Shows"])
        //mediaTypeSelector.frame = CGRect(x: 8, y: 0, width: (self.view.frame.width - 16), height: 50)

        mediaTypeSelector.selectedSegmentIndex = 0
        mediaTypeSelector.translatesAutoresizingMaskIntoConstraints = false
        mediaTypeSelector.addTarget(self, action: #selector(UpdateFavoriteList(_:)), for: .valueChanged)

        //navigationItem.titleView = mediaTypeSelector
        
        
        view.backgroundColor = .systemGroupedBackground
        self.title = Tabs.favorite.rawValue
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 96
        tableView.separatorStyle = .singleLine
        
        view.addSubview(mediaTypeSelector)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            mediaTypeSelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mediaTypeSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mediaTypeSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mediaTypeSelector.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: mediaTypeSelector.bottomAnchor, constant: 16),
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
                                                           deleteAnimation: .none),
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
    @objc private func UpdateFavoriteList(_ sender: UISegmentedControl) {
        currentMediaType = mediaTypeSelector.selectedSegmentIndex == 0 ? .movie : .tv
        fetchFavorite(withMediaType: currentMediaType)
    }
}




extension FavoriteViewController {
    
    func fetchFavorite(withMediaType: MediaType) {
        
        favoriteViewModel.fetchFavorite(withMediaType: currentMediaType, disposeBag)
    }
    
    func bindDataSource() {
        
        /// fetch Trending
        fetchFavorite(withMediaType: currentMediaType)
        
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
