//
//  LoginViewModel.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 24/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelCoordinatorDelegate: AnyObject {
    func userDidLogin(user: User)
}

final class LoginViewModel {
    
    weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?
    
    private var apiClient: APIClientProtocol
    
    typealias Input = (
        username : Observable<String>,
        password : Observable<String>,
        didPressLoginButton: Observable<Void>
    )
    
    typealias Builder = (LoginViewModel.Input) -> LoginViewModel
    
    var input: LoginViewModel.Input
    var user: Observable<User>
    
    init(apiClient: APIClient = APIClient(),
         input: LoginViewModel.Input) {
        
        self.apiClient = apiClient
        self.input = input
        
        let inputs = Observable.combineLatest(input.username, input.password) { (username, password) -> (String, String) in
            return (username, password)
        }
        user = Observable.of(User.Empty())
        user = self.didPressLoginButton(inputs: inputs)
        
    }
    
    func didPressLoginButton(inputs: Observable<(String, String)>) -> Observable<User> {
        return input.didPressLoginButton
            .withLatestFrom(inputs)
            .flatMap { [self] (username, password) in
                return sendLoginRequest(username, password)
            }
            .map { user in
                user
            }
    }
    
    private var isUsernameValid: Observable<Bool> {
        return input.username
            .map {
                return Helpers.isUsernameValid($0)
            }
    }
    
    private var isPasswordValid: Observable<Bool> {
        return input.password
            .map {
                return Helpers.isPasswordValid($0)
            }
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(isUsernameValid, isPasswordValid)
            .map {
                return $0.0 && $0.1
            }
            .startWith(false)
    }
    
    func sendLoginRequest(_ username: String, _ password: String) -> Observable<User> {
        let userDetails = apiClient.perform(TokenEndpoint.getNewRequestToken)
            .map({ response -> Token in
                return response
            })
            .map({ response -> String in
                let token = response.requestToken ?? ""
                print("&&& token 1 -> \(token)")
                return token
            })
            .flatMap({ token in
                self.apiClient.perform(TokenEndpoint.validateTokenWith(
                    username: username,
                    password: password,
                    requestToken: token))
                .map { response -> Token in
                    return response
                }
                .map({ response -> String in
                    let token = response.requestToken ?? ""
                    print("&&& token 2 -> \(token)")
                    return token
                })
            })
            .flatMap({ token in
                self.apiClient.perform(SessionEndpoint.createSession(requestToken: token))
                    .map { response -> SessionResponse in
                        return response
                    }
                    .map({ sessionResponse -> String in
                        let sessionID = sessionResponse.sessionID ?? ""
                        Session.setSessionID(sessionID: sessionID)
                        print("&&& sessionID 1 -> \(sessionID)")
                        return sessionID
                    })
            })
            .flatMap({ sessionID in
                self.apiClient.perform(AccountEndpoint.getAccountDetails(sessionID: sessionID))
                    .map { response -> User in
                        return response
                    }
            })
        
        return userDetails
    }
    
}


class Helpers {
    
    static func isUsernameValid(_ usernameStr: String) -> Bool {
        return usernameStr.count > 4
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        return password.count > 4
    }
}
