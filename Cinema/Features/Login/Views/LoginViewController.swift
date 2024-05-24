//
//  LoginViewController.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 24/1/2023.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    private var loginView : LoginView!
    
    var coordinatorDelegate: LoginViewModelCoordinatorDelegate?
    var loginViewModel: LoginViewModel!
    var loginViewModelBuilder: LoginViewModel.Builder!
    
    private var disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        loginView = LoginView()
        view.addSubview(loginView)
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = loginViewModelBuilder((
            username: loginView.username.rx.text.orEmpty.asObservable(),
            password: loginView.password.rx.text.orEmpty.asObservable(),
            didPressLoginButton: loginView.button.rx.tap.asObservable()
        ))


        setupBindings()
        loginViewModel.user
            .observe(on: MainScheduler.instance)
            .subscribe(
                    onNext: { [weak self] user in
                        self?.coordinatorDelegate?.userDidLogin(user:user)
                        print("User &&& \(user)")
                    },
                    onError: { error in
                        print("ERROR &&& \(error)")
                    }
                )
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
    
        loginViewModel?.isValid()
            .bind(to: loginView.button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel?.isValid()
            .map { $0 ? 1 : 0.5 }
            .bind(to: loginView.button.rx.alpha)
            .disposed(by: disposeBag)
        
    }
    
}
