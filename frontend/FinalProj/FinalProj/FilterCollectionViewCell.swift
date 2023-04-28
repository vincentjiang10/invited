//
//  FilterCollectionViewCell.swift
//  finalproj
//
//  Created by Big Mac on 4/28/23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.backgroundColor = .systemMint
        contentView.addSubview(label)
        
        setupConstraints()
    }
    
    func configure(filterName: String) {
        label.text = filterName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.widthAnchor.constraint(equalToConstant: 115),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
    }

}

