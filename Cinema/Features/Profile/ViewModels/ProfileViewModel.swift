//
//  ProfileViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 31/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileViewModelProfileCoordinatorDelegate: AnyObject {
    func accountDetailsSelected()
    func favoritesSelected()
    func settingsSelected()
}

protocol ProfileViewModelTabCoordinatorDelegate: AnyObject {
    func userDidLogout()
}


final class ProfileViewModel {
    
    private var apiClient: APIClientProtocol
    
    weak var profileCoordinatorDelegate: ProfileViewModelProfileCoordinatorDelegate?
    weak var tabCoordinatorDelegate: ProfileViewModelTabCoordinatorDelegate?

    /*typealias Input = (User)
    
    typealias Builder = (ProfileViewModel.Input) -> ProfileViewModel
    
    var input: ProfileViewModel.Input*/
    
    var user: User
        
    init(apiClient: APIClient = APIClient(), user: User) {
        self.apiClient = apiClient
        self.user = user
    }
    
    func getProfileRows() -> Driver<[ProfileRowSection]> {
        return Observable.just(ProfileRows.allCases)
            .map({ items -> [ProfileRowSection] in
                return [ProfileRowSection (
                    model: 0,
                    items: items.filter({ profileRows in
                        profileRows == ProfileRows.header
                    })
                ),ProfileRowSection (
                    model: 1,
                    items: items.filter({ profileRows in
                        profileRows != ProfileRows.logout &&  profileRows != ProfileRows.header
                    })
                ),ProfileRowSection (
                    model: 2,
                    items: items.filter({ profileRows in
                        profileRows == ProfileRows.logout
                    })
                )]
            })
            .asDriver(onErrorJustReturn: [])
    }
    
    func downloadAvatar(for user: User) -> Observable<UIImage> {
        return apiClient
            .perform(ImageEndpoint
                .downloadAvatar(avatarHash: user.avatar.gravatar.hash))
    }
}
