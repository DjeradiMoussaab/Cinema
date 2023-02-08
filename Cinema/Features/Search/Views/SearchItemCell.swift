//
//  SearchItemCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 19/1/2023.
//

import Foundation
import UIKit


class SearchItemCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: SearchItemCell.self) }

    let searchImageView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 36
        v.backgroundColor = .darkGray
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    let title : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .title3)
        v.textColor = .label
        v.numberOfLines = 2
        v.textAlignment = .left
        return v
    }()
    
    let releaseDate : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = .label
        return v
    }()
    
    let rating : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = .label
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
        let stackView = UIStackView(arrangedSubviews: [title, releaseDate, rating])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        addSubview(searchImageView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            searchImageView.widthAnchor.constraint(equalToConstant: 72),
            searchImageView.heightAnchor.constraint(equalToConstant: 72),
            searchImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.heightAnchor.constraint(equalToConstant: 20),
            releaseDate.heightAnchor.constraint(equalToConstant: 12),
            rating.heightAnchor.constraint(equalToConstant: 12),

            stackView.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            
        ])
        stackView.setCustomSpacing(8, after: title)
    }

    func configure(with item: SearchItemViewModel) {
        title.text = item.title
        releaseDate.text = "Released on:\(item.releaseDate)"
        rating.text = "Rated: \(item.rating)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchImageView.image = nil
    }
    
}
