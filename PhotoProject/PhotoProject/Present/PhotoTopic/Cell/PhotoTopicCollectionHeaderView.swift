//
//  PhotoTopicCollectionHeaderView.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import UIKit

import SnapKit
import Then

final class PhotoTopicCollectionHeaderView: UICollectionReusableView {
    
    static let elementKinds: String = "PhotoTopicCollectionHeaderView"
    
    static let identifier = "PhotoTopicCollectionHeaderView"
    
    private let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    private func setHierarchy() {
        addSubview(headerLabel)
    }
    
    private func setLayout() {
        headerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func setStyle() {
        headerLabel.setLabelUI("testHeader", font: .systemFont(ofSize: 18, weight: .black))
    }
    
    func setTitle(title: String) {
        headerLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
