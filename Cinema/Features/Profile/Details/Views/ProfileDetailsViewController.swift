//
//  ProfileDetailsViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 2/5/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProfileDetailsViewController: UIViewController {
    
    
    private var profileDetailsView : ProfileDetailsView!
    
    var profileDetailsViewModel: ProfileDetailsViewModel!
    var profileDetailsViewModelBuilder: ProfileDetailsViewModel.Builder!

    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ProfileDetailsSection>(configureCell: { datasource, tableView, indexPath, item in
        let profileDetailsItemCell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailsCell.reuseIdentifier, for: indexPath) as! ProfileDetailsCell
        switch item {
        case .name:
            profileDetailsItemCell.configure(with: item.rawValue, info: self.profileDetailsViewModel.user.name)
        case .username:
            profileDetailsItemCell.configure(with: item.rawValue, info: self.profileDetailsViewModel.user.username)
        case .isAdult:
            profileDetailsItemCell.configure(with: item.rawValue, info: self.profileDetailsViewModel.user.includeAdult ? "YES" : "NO")
        case .language:
            profileDetailsItemCell.configure(with: item.rawValue, info: self.profileDetailsViewModel.user.iso639_1)
        case .country:
            profileDetailsItemCell.configure(with: item.rawValue, info: self.profileDetailsViewModel.user.iso3166_1)
        }
        return profileDetailsItemCell
    })
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        setupBindings()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.isTranslucent = true
        
        profileDetailsView = ProfileDetailsView(frame: self.view.frame)
        view.addSubview(profileDetailsView)
        NSLayoutConstraint.activate([
            profileDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        //tableView.register(ProfileHeaderCell.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        profileDetailsViewModel.getProfileDetailsRows()
            .drive(profileDetailsView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

