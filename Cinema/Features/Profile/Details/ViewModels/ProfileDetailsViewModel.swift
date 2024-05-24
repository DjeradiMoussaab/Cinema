//
//  ProfileDetailsViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 2/5/2023.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileDetailsViewModel {
    
    private var apiClient: APIClientProtocol
    
    typealias Input = (User)
    
    typealias Builder = (ProfileDetailsViewModel.Input) -> ProfileDetailsViewModel
    
    var input: ProfileViewModel.Input
    
    var user: User
        
    init(apiClient: APIClient = APIClient(), input: User) {
        self.apiClient = apiClient
        self.input = input
        self.user = input
    }
    
    func getProfileDetailsRows() -> Driver<[ProfileDetailsSection]> {
        return Observable.just(ProfileDetailsRows.allCases)
            .map({ profileDetailsRows in
                [ProfileDetailsSection(
                    model: 0,
                    items: profileDetailsRows.filter({ ProfileDetailsRows in
                        ProfileDetailsRows != .language &&
                        ProfileDetailsRows != .country
                    })
                ),
                 ProfileDetailsSection(
                     model: 1,
                     items: profileDetailsRows.filter({ ProfileDetailsRows in
                         ProfileDetailsRows == .country ||
                         ProfileDetailsRows == .language
                     })
                 )]
            })
            .asDriver(onErrorJustReturn:
                        [ProfileDetailsSection(
                            model: 0,
                            items: []
                        )])
    }
    
    /*func getProfileDetailsRows() -> Driver<[ProfileDetailsSection]> {
        return Observable.just(ProfileDetailsRows.allCases)
            .map({ items -> [ProfileDetailsSection] in
                return [ProfileRowSection (
                    model: 0,
                    items: items.filter({ profileRows in
                        profileRows != ProfileDetailsRows.language &&
                        profileRows != ProfileDetailsRows.country
                    })
                ),ProfileRowSection (
                    model: 1,
                    items: items.filter({ profileRows in
                        profileRows == ProfileDetailsRows.language ||
                        profileRows == ProfileDetailsRows.country
                    })
                )]
            })
            .asDriver(onErrorJustReturn: [])
    }*/
    
    func downloadAvatar(for user: User) -> Observable<UIImage> {
        return apiClient
            .perform(ImageEndpoint
                .downloadAvatar(avatarHash: user.avatar.gravatar.hash))
    }
}
