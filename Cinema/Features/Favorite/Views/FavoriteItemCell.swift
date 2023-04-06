//
//  FavoriteItemCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 15/2/2023.
//

import Foundation
import UIKit

class FavoriteItemCell: UITableViewCell {
    
    static var reuseIdentifier: String { String(describing: FavoriteItemCell.self) }

    let itemImageView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 40
        v.backgroundColor = .darkGray
        v.contentMode = .scaleToFill
        return v
    }()
    
    let title : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .title3)
        v.textColor = .label
        v.numberOfLines = 2
        v.textAlignment = .left
        v.baselineAdjustment = .alignCenters
        return v
    }()
    
    let releaseDate : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = .label
        v.baselineAdjustment = .alignCenters
        return v
    }()
    
    let rating : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = .label
        v.baselineAdjustment = .alignCenters
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
        selectionStyle = .none
        backgroundColor = .systemBackground
        shouldIndentWhileEditing = true
        contentMode = .scaleToFill
        let stackView = UIStackView(arrangedSubviews: [title, releaseDate, rating])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        
        let stackViewParent = UIStackView(arrangedSubviews: [itemImageView, stackView])
        stackViewParent.translatesAutoresizingMaskIntoConstraints = false
        stackViewParent.axis = .horizontal
        stackViewParent.spacing = 8
        
        contentView.addSubview(stackViewParent)

        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: 80),
            itemImageView.heightAnchor.constraint(equalToConstant: 80),
            
            title.heightAnchor.constraint(equalToConstant: 40),
            releaseDate.heightAnchor.constraint(equalToConstant: 20),
            rating.heightAnchor.constraint(equalToConstant: 20),

            
            stackViewParent.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackViewParent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bottomAnchor.constraint(equalTo: stackViewParent.bottomAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: stackViewParent.trailingAnchor, constant: 8),

            
        ])
        stackView.setCustomSpacing(8, after: title)
    }

    func configure(with item: FavoriteItemViewModel) {
        title.text = item.title
        releaseDate.text = "Released on:\(item.releaseDate)"
        rating.text = "Rated: \(item.rating)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
    }
    
}
