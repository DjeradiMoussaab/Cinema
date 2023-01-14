//
//  HeaderCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 9/1/2023.
//

import Foundation
import UIKit


class HeaderCell: UICollectionViewCell {
    
    static var reuseIdentifier: String { String(describing: HeaderCell.self) }

    
    let title : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 28, weight: .heavy)
        v.textColor = .label
        v.numberOfLines = 2
        v.textAlignment = .left
        return v
    }()
    
    let subtitle : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 26, weight: .ultraLight)
        v.textColor = .red
        v.sizeToFit()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemBackground
        let stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
 
        ])
    }

    func configure(with info: (String,String)) {
        self.title.text = info.0
        self.subtitle.text = info.1
    }
    
}
