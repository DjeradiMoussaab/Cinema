//
//  TrendingViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TrendingViewController: UIViewController {
    
    private var trendingViewModel = TrendingViewModel()
    
    private let disposeBag = DisposeBag()
    
    var collectionView: UICollectionView!

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<MediaItemSection>(configureCell:{ dataSource, collectionView, indexPath, item in
        
        let mediaItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCell.reuseIdentifier, for: indexPath) as! MediaItemCell
        self.trendingViewModel.downloadImage(for: item)
            .bind(to: mediaItemCell.imageView.rx.image)
            .disposed(by: self.disposeBag)
        mediaItemCell.configure(with: item)
        return mediaItemCell
    })
    
    override func viewDidLoad() {
        setupViews()
        populateTrending(withTimePeriod: .daily)
        
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        self.title = Tabs.trending.rawValue

        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.reuseIdentifier)
        self.collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier)
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier, for: indexPath) as! HeaderCell
            if indexPath.section == 0 {
                cell.configure(with: ("TRENDING", "TV SHOWS"))
            } else {
                cell.configure(with: ("TRENDING", "MOVIES"))
            }
            return cell
        }
        
        view.addSubview(collectionView)
    }
    
    
    func populateTrending(withTimePeriod period: TimePeriod) {
        /// fetch Trending
        trendingViewModel.fetchTrending(withTimePeriod: .daily, disposeBag)

        /// use dailyTrending after fetching is completed
        trendingViewModel.trending
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }

}

// MARK: - COMPOSITIONAL LAYOUT

extension TrendingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if (sectionIndex == 0 ) {
                return self.createHorizontalSectionLayout()
            } else {
                return self.createVericalSectionLayout()
            }
        }
        return layout
    }

    private func createHorizontalSectionLayout() -> NSCollectionLayoutSection {
        
        /// create sizes for items and groups.
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(240))

        /// create item and group.
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupeSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(40))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        
        
        /// create the section.
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createVericalSectionLayout() -> NSCollectionLayoutSection {
        
        /// create sizes for items and groups.
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(260))

        /// create item and group.
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupeSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(40))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        
        /// create the section.
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
