//
//  ProfileAccountCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 6/2/2023.
//

import Foundation
import UIKit

class ProfileAccountCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: ProfileAccountCell.self) }

    let profilePicture: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = .systemGray4
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 32
        //v.layer.borderWidth = 2
        //v.layer.borderColor = UIColor.darkGray.cgColor
        return v
    }()
    
    let username: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .title3)
        v.textColor = .label
        v.numberOfLines = 1
        v.textAlignment = .left
        v.text = "Mossab Djeradi"
        return v
    }()
    
    let id: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .footnote)
        v.textColor = .label
        v.numberOfLines = 1
        v.textAlignment = .left
        v.text = "Apple ID: 01924215"
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator

        let stackView = UIStackView(arrangedSubviews: [username, id])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.alignment = .leading
        addSubview(stackView)
        addSubview(profilePicture)

        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: 80),
            
            profilePicture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profilePicture.heightAnchor.constraint(equalToConstant: 64),
            profilePicture.widthAnchor.constraint(equalToConstant: 64),
            profilePicture.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            username.heightAnchor.constraint(equalToConstant: 20),
            id.heightAnchor.constraint(equalToConstant: 20),

            stackView.heightAnchor.constraint(equalToConstant: 40),

            stackView.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),

            
        ])
    }
    
    func configure(user: User) {
        username.text = user.username
        id.text = "User ID: \(user.id)"
    }
    
}
