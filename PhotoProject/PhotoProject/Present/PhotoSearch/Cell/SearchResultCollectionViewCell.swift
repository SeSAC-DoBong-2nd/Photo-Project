//
//  SearchResultCollectionViewCell.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    
    let starContainerView = UIView()
    let starImageView = UIImageView()
    let startCountLabel = UILabel()
    
    let heartBtn = UIButton()
    
    override func setHierarchy() {
        contentView.addSubviews(imageView,
                                starContainerView,
                                heartBtn)
        
        starContainerView.addSubviews(starImageView, startCountLabel)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        starContainerView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }
        
        starImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.size.equalTo(20)
        }
        
        startCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        heartBtn.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(45)
        }
    }
    
    override func setStyle() {
        imageView.backgroundColor = .blue
        starContainerView.backgroundColor = .red
        
        starImageView.do {
            $0.backgroundColor = .clear
            $0.image = UIImage(systemName: "star.fill")
            $0.tintColor = .systemYellow
        }
        
        starContainerView.do {
            $0.layer.cornerRadius = 30/2
            $0.backgroundColor = .darkGray
        }
        
        
        heartBtn.backgroundColor = .cyan
        
        startCountLabel.setLabelUI(12345.formatted(), font: .systemFont(ofSize: 12, weight: .medium), textColor: .white)
        
        heartBtn.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 45/2
            $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            $0.backgroundColor = .lightGray.withAlphaComponent(0.6)
            $0.imageView?.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(6)
            }
        }
    }
    
    func configureCell(image: String) {
        imageView.image = UIImage(systemName: image)
    }
    
}
