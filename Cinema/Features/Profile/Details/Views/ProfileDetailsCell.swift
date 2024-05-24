//
//  ProfileDetailsCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 2/5/2023.
//

import Foundation
import UIKit

class ProfileDetailsCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: ProfileDetailsCell.self) }
    
    let title : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .callout)
        v.textColor = .label
        v.numberOfLines = 1
        v.textAlignment = .left
        return v
    }()
    
    let info : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .callout)
        v.textColor = .gray
        v.numberOfLines = 1
        v.textAlignment = .right
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
        accessoryType = .none
        selectionStyle = .none

        
        let stackView = UIStackView(arrangedSubviews: [title,info])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.alignment = .center
        addSubview(stackView)

        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 40),
            info.heightAnchor.constraint(equalToConstant: 40),

            stackView.heightAnchor.constraint(equalToConstant: 40),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            
        ])
    }

    func configure(with title: String, info: String) {
        self.title.text = title
        self.info.text = info
    }
    
    
}
