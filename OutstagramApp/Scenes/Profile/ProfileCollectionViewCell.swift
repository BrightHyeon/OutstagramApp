//
//  ProfileCollectionViewCell.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/07.
//

import UIKit
import SnapKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
//    private let alphaAmount: [CGFloat] = [0.2, 0.4, 0.6]
    
    private let imageView = UIImageView()
    
    func setup(with image: UIImage) {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
//        imageView.backgroundColor = .tertiaryLabel.withAlphaComponent(alphaAmount.randomElement() ?? 0.4)
        imageView.image = image
    }
}
