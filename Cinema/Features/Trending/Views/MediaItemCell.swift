//
//  MediaItemCell.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 4/1/2023.
//

import Foundation
import UIKit


class MediaItemCell: UICollectionViewCell {
    
    static var reuseIdentifier: String { String(describing: MediaItemCell.self) }

    let imageView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = .darkGray
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    let title : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = .label
        v.numberOfLines = 2
        v.textAlignment = .left
        return v
    }()
    
    let releaseDate : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption2)
        v.textColor = .label
        return v
    }()
    
    let rating : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.preferredFont(forTextStyle: .caption2)
        v.textColor = .label
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
        let stackView = UIStackView(arrangedSubviews: [imageView, title, releaseDate, rating])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 280),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            //imageView.widthAnchor.constraint(equalToConstant: 200),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            
        ])
        stackView.setCustomSpacing(8, after: title)
    }

    func configure(with item: MediaItemViewModel) {
        title.text = item.title
        releaseDate.text = item.releaseDate
        rating.text = "\(item.rating)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
