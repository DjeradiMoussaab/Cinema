//
//  profileViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 31/1/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class ProfileViewController: UIViewController {
    
    private var profileView : ProfileView!
    
    var profileViewModel: ProfileViewModel!
    //var profileViewModelBuilder: ProfileViewModel.Builder!
    
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ProfileRowSection>(configureCell: { datasource, tableView, indexPath, item in
        
        switch item {
        case .header:
            let profileItemCell = tableView.dequeueReusableCell(withIdentifier: ProfileAccountCell.reuseIdentifier, for: indexPath) as! ProfileAccountCell
            profileItemCell.configure(user: self.profileViewModel.user)
            self.profileViewModel.downloadAvatar(for: self.profileViewModel.user)
                .bind(to: profileItemCell.profilePicture.rx.image)
                .disposed(by: self.disposeBag)
            return profileItemCell
        case .logout:
            let profileItemCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
            profileItemCell.title.textColor = .red
            profileItemCell.icon.tintColor = .red
            profileItemCell.configure(with: item.infos().label , icon: item.infos().icon)
            return profileItemCell
        default:
            let profileItemCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as! ProfileCell
            profileItemCell.configure(with: item.infos().label , icon: item.infos().icon)
            return profileItemCell
        }
    })
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        Session.userDeconnected()
        setupBindings()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        tabBarController?.tabBar.isTranslucent = true
        
        profileView = ProfileView(frame: self.view.frame)
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        //tableView.register(ProfileHeaderCell.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        profileViewModel.getProfileRows()
            .drive(profileView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        profileView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                switch self?.dataSource[indexPath] {
                case .header:
                    self?.profileViewModel.profileCoordinatorDelegate?.accountDetailsSelected()
                case .details:
                    self?.profileViewModel.profileCoordinatorDelegate?.accountDetailsSelected()
                case .favorite:
                    self?.profileViewModel.profileCoordinatorDelegate?.favoritesSelected()
                case .settings:
                    self?.profileViewModel.profileCoordinatorDelegate?.settingsSelected()
                case .logout:
                    self?.profileViewModel.tabCoordinatorDelegate?.userDidLogout()
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
}

