//
//  LoginView.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 29/1/2023.
//

import Foundation
import UIKit

class LoginView : UIView {
    
    let headerImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "Cinema")
        return v
    }()
    
    let pageTitle: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 38, weight: .heavy)
        v.numberOfLines = 2
        v.textAlignment = .left
        v.text = "Welcome to CINEMA App!"
        v.textAlignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let descriptionTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 16, weight: .thin)
        v.numberOfLines = 3
        v.textAlignment = .center
        v.text = "To Login to CINEMA App : \n Use your TMDB login credentials."
        v.textAlignment = .center
        return v
    }()
    
    let username: UITextField = {
        let v = UITextField()
        v.borderStyle = .roundedRect
        v.placeholder  = "Username"
        v.textContentType = .username
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let password: UITextField = {
        let v = UITextField()
        v.borderStyle = .roundedRect
        v.placeholder = "Password"
        v.textContentType = .password
        v.isSecureTextEntry = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let button: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        v.setTitleColor(UIColor.white, for: .normal)
        v.setTitle("Login", for: .normal)
        v.layer.cornerRadius = 10
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [headerImage, pageTitle, descriptionTitle, username, password, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            headerImage.heightAnchor.constraint(equalToConstant: 320),
            headerImage.widthAnchor.constraint(equalToConstant: 320),
            
            username.heightAnchor.constraint(equalToConstant: 40),
            username.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            username.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            password.heightAnchor.constraint(equalToConstant: 40),
            password.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
    }
    
}
