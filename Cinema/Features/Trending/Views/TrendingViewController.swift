//
//  TrendingViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TrendingViewController: UIViewController {

    private var trendingViewModel = TrendingViewModel()
    private let disposeBag = DisposeBag()
    
    var collectionView: UICollectionView!
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<MediaItemSection>(
        configureCell: configureCell,
        configureSupplementaryView: configureSupplementaryView
    )
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        populateTrending(withTimePeriod: .daily)
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = Tabs.trending.rawValue
        setupCollectionView()
        setupRxDataSource()
        view.addSubview(collectionView)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MediaItemCell.self, forCellWithReuseIdentifier: MediaItemCell.reuseIdentifier)
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier)
    }

    private func setupRxDataSource() {
        dataSource.configureSupplementaryView = configureSupplementaryView
    }

    private func populateTrending(withTimePeriod period: TimePeriod) {
        trendingViewModel.fetchTrending(withTimePeriod: .daily, disposeBag)
        trendingViewModel.trending
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }


    // MARK: - Layout

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            return sectionIndex == 0 ? self.createHorizontalSectionLayout() : self.createVericalSectionLayout()
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

    // MARK: - RxDataSource Configuration

    private func configureCell(dataSource: CollectionViewSectionedDataSource<MediaItemSection>, collectionView: UICollectionView, indexPath: IndexPath, item: MediaItemSection.Item) -> UICollectionViewCell {
        let mediaItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCell.reuseIdentifier, for: indexPath) as! MediaItemCell
        trendingViewModel.downloadImage(for: item)
            .bind(to: mediaItemCell.imageView.rx.image)
            .disposed(by: disposeBag)
        mediaItemCell.configure(with: item)
        return mediaItemCell
    }

    private func configureSupplementaryView(dataSource: CollectionViewSectionedDataSource<MediaItemSection>, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier, for: indexPath) as! HeaderCell
        cell.configure(with: indexPath.section == 0 ? ("TRENDING", "TV SHOWS") : ("TRENDING", "MOVIES"))
        return cell
    }
}
