//
//  TrendingView.swift
//  Cinema
//
//  Created by Moussaab Djeradi on 28/12/2022.
//

import Foundation
import UIKit

class TrendingView: UIView {

    let mediaImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8.0
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .black
        addSubview(mediaImage)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([

            mediaImage.topAnchor.constraint(equalTo: topAnchor),
            mediaImage.leadingAnchor.constraint(equalTo: leadingAnchor),

            mediaImage.heightAnchor.constraint(equalToConstant: 200),
            mediaImage.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
