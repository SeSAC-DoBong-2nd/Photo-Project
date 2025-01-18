//
//  PhotoSearchView.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

import SnapKit
import Then

final class PhotoSearchView: BaseView {
    
    var searchResultState = SearchResultState.none
    
    let underLineView = UIView()
    
    let scrollView = UIScrollView()
    let contentsView = UIView()
    let stackView = UIStackView()
    lazy var blackButton = UIButton()
    lazy var whiteButton = UIButton()
    lazy var yellowButton = UIButton()
    lazy var redButton = UIButton()
    lazy var purpleButton = UIButton()
    lazy var greenButton = UIButton()
    lazy var blueButton = UIButton()
    lazy var colorFilterBtnArr = [blackButton, whiteButton, yellowButton, redButton, purpleButton, greenButton, blueButton]
    
    let toggleButton = UISwitch()
    
    let emptyView = UIView()
    let emptyLabel = UILabel()
    lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    override func setHierarchy() {
        addSubviews(underLineView, scrollView, toggleButton, emptyView, searchCollectionView)
        
        scrollView.addSubview(contentsView)
        contentsView.addSubview(stackView)
        stackView.addArrangedSubviews(blackButton,
                                      whiteButton,
                                      yellowButton,
                                      redButton,
                                      purpleButton,
                                      greenButton,
                                      blueButton)
        
        emptyView.addSubview(emptyLabel)
    }
    
    override func setLayout() {
        underLineView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.6)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(underLineView)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.height.equalTo(scrollView)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        searchCollectionView.snp.makeConstraints{
            $0.edges.equalTo(emptyView)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setStyle() {
        underLineView.do {
            $0.backgroundColor = .lightGray
        }
        
        scrollView.do {
            $0.layer.backgroundColor = UIColor.white.cgColor
            $0.showsHorizontalScrollIndicator = false
        }
        
        contentsView.do {
            $0.backgroundColor = .brown
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 1
            $0.distribution = .equalSpacing
        }
        
        buttonUI(btnArr: colorFilterBtnArr)
        
        emptyView.do {
            $0.backgroundColor = .systemPink
            $0.isHidden = searchResultState.isEmptyViewHidden
        }
        
        searchCollectionView.do {
            $0.isHidden = !searchResultState.isEmptyViewHidden
        }
        
        emptyLabel.setLabelUI(searchResultState.title,
                              font: .systemFont(ofSize: 18, weight: .black),
                              alignment: .center)
        
        searchCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 4
            layout.minimumLineSpacing = 4
            
            let screenWidth = UIScreen.main.bounds.width
            layout.itemSize = CGSize(width: (screenWidth-4)/2, height: 250)
            $0.collectionViewLayout = layout
            $0.register(SearchResultCollectionViewCell.self,
                        forCellWithReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier)
        }
    }

}

private extension PhotoSearchView {
    
    func buttonUI(btnArr: [UIButton]) {
        for i in 0..<colorFilterBtnArr.count {
            var buttonConfig = UIButton.Configuration.gray()
            
            let colorFilterBtnTitleArr = PhotoSearchColorButton.allCases
            let buttonTitle = colorFilterBtnTitleArr[i].rawValue

            var attributedTitle = AttributedString(buttonTitle)
            attributedTitle.foregroundColor = .black
            attributedTitle.font = .systemFont(ofSize: 16, weight: .bold)
            buttonConfig.attributedTitle = attributedTitle
            
            buttonConfig.image = UIImage(systemName: "circle.fill")
            buttonConfig.imagePadding = 5
            buttonConfig.baseBackgroundColor = .lightGray.withAlphaComponent(0.6)
            
            let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .normal:
                    button.configuration?.background.backgroundColor = .lightGray.withAlphaComponent(0.6)
                    var attributedTitle = AttributedString(button.configuration?.title ?? "")
                    attributedTitle.foregroundColor = .black
                    button.configuration?.attributedTitle = attributedTitle
                case .selected:
                    button.configuration?.background.backgroundColor = .systemBlue
                    var attributedTitle = AttributedString(button.configuration?.title ?? "")
                    attributedTitle.foregroundColor = .white
                    button.configuration?.attributedTitle = attributedTitle
                default:
                    return
                }
            }
            
            colorFilterBtnArr[i].configuration = buttonConfig
            colorFilterBtnArr[i].configurationUpdateHandler = buttonStateHandler
            colorFilterBtnArr[i].tintColor = colorFilterBtnTitleArr[i].buttonimageColor
            
            colorFilterBtnArr[i].snp.makeConstraints {
                $0.centerY.equalToSuperview()
            }
            
            colorFilterBtnArr[i].do {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 18
//                $0.tintColor = colorFilterBtnTitleArr[i].buttonimageColor
                $0.addTarget(self, action: #selector(tappedBtn), for: .touchUpInside)
            }
        }
    }
    
    @objc
    func tappedBtn(_ sender: UIButton) {
        for i in colorFilterBtnArr {
            if i == sender {
                i.isSelected = true
            } else {
                i.isSelected = false
            }
        }
        print(#function)
    }
    
}
