//
//  ProfileHeaderCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 6/2/2023.
//

import Foundation
import UIKit

class ProfileView : UIView {

    let tableView: UITableView = {
        let v = UITableView(frame: CGRect.zero, style: .insetGrouped)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGroupedBackground
        //v.backgroundColor = .lightGray
        v.rowHeight = UITableView.automaticDimension
        v.estimatedRowHeight = 40
        v.isScrollEnabled = false
        v.separatorStyle = .singleLine
        v.register(ProfileAccountCell.self, forCellReuseIdentifier: ProfileAccountCell.reuseIdentifier)
        v.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        return v
    }()
    
    let bottomText: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = .label
        v.numberOfLines = 3
        v.textAlignment = .left
        v.textAlignment = .center
        v.text = "Version 1.0 (1.0.0) \n \n Copyright © 2023 CINEMA"
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
        backgroundColor = .systemGroupedBackground
        addSubview(tableView)
        addSubview(bottomText)

        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomText.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            bottomText.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomText.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
