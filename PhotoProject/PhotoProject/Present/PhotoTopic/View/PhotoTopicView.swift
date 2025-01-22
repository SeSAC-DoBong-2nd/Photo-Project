//
//  PhotoTopicView.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import UIKit

import SnapKit
import Then

final class PhotoTopicView: BaseView {
    
    private let titleLabel = UILabel()
    lazy var topicCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    
    override func setHierarchy() {
        addSubviews(titleLabel, topicCollectionView)
    }
    
    override func setLayout() {
        print("🔥")
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(15)
        }
        
        topicCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setStyle() {
        titleLabel.setLabelUI("OUR TOPIC", font: .systemFont(ofSize: 36, weight: .heavy))
    }
    
}

private extension PhotoTopicView {
    
    // MARK: - Compositional Layout
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            
            return self.createHorizontalScrollSection()
        }
    }
    
    func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: PhotoTopicCollectionHeaderView.elementKinds,
                                                                 alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
}
