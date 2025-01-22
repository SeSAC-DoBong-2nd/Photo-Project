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
    
    var searchResultState = SearchResultStateType.yet
    var toggleButtonState = ToggleButtonStateType.relevant
    
    private let underLineView = UIView()
    
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private let stackView = UIStackView()
    private lazy var blackButton = UIButton()
    private lazy var whiteButton = UIButton()
    private lazy var yellowButton = UIButton()
    private lazy var redButton = UIButton()
    private lazy var purpleButton = UIButton()
    private lazy var greenButton = UIButton()
    private lazy var blueButton = UIButton()
    private lazy var emptyButton = UIButton()
    lazy var colorFilterBtnArr = [blackButton, whiteButton, yellowButton, redButton, purpleButton, greenButton, blueButton, emptyButton]
    
    let toggleButton = UIButton()
    
    private let emptyView = UIView()
    private let emptyLabel = UILabel()
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
                                      blueButton,
                                      emptyButton)
        
        emptyView.addSubview(emptyLabel)
    }
    
    override func setLayout() {
        underLineView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.6)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(underLineView).offset(2)
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
        
        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(8)
            $0.centerY.equalTo(scrollView.snp.centerY)
            $0.height.equalTo(stackView.snp.height)
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
//            $0.bouncesHorizontally = false
        }
        
        contentsView.do {
            $0.backgroundColor = .clear
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 1
            $0.distribution = .equalSpacing
        }
        
        setColorFilterBtnUI(btnArr: colorFilterBtnArr)
        
        setToggleBtnUI(btn: toggleButton)
        
        emptyView.do {
            $0.backgroundColor = .clear
            $0.isHidden = searchResultState.isEmptyViewHidden
        }
        
        searchCollectionView.do {
            $0.isHidden = !searchResultState.isEmptyViewHidden
        }
        
        emptyLabel.setLabelUI(searchResultState.title ?? "",
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
    
    //api에서도 query 없이는 검색이 안되는 것에 따라 text를
    //  입력하기 전까지는 colorBtn과 toggleBtn이 눌리면 안될 것 같아 이렇게 설정하였습니다.
    func setBtnAbled() {
        for i in colorFilterBtnArr {
            i.isEnabled = true
        }
        toggleButton.isEnabled = true
    }
    
    func searchResultState(state: SearchResultStateType) {
        emptyView.isHidden = state.isEmptyViewHidden
        searchCollectionView.isHidden = !state.isEmptyViewHidden
        emptyLabel.text = searchResultState.title
    }

}

//MARK: - private extension
private extension PhotoSearchView {
    
    func setColorFilterBtnUI(btnArr: [UIButton]) {
        for i in 0..<colorFilterBtnArr.count {
            var buttonConfig = UIButton.Configuration.gray()
            
            let colorFilterBtnTitleArr = PhotoSearchColorButtonType.allCases
            let buttonTitle = colorFilterBtnTitleArr[i].rawValue

            var attributedTitle = AttributedString(buttonTitle)
            attributedTitle.foregroundColor = .black
            attributedTitle.font = .systemFont(ofSize: 16, weight: .bold)
            buttonConfig.attributedTitle = attributedTitle
            
            buttonConfig.image = UIImage(systemName: "circle.fill")
            buttonConfig.imagePadding = 5
            buttonConfig.baseBackgroundColor = .lightGray.withAlphaComponent(0.6)
            
            let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
                if button == self.emptyButton {
                    button.configuration?.background.backgroundColor = .clear
                    button.configuration?.image = .none
                    return
                }
                switch button.state {
                case .normal:
                    button.configuration?.background.backgroundColor = .lightGray.withAlphaComponent(0.4)
                    var attributedTitle = AttributedString(button.configuration?.title ?? "")
                    attributedTitle.foregroundColor = .black
                    button.configuration?.attributedTitle = attributedTitle
                case .selected:
                    button.configuration?.background.backgroundColor = .systemBlue.withAlphaComponent(0.6)
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
                $0.isEnabled = false
            }
        }
    }
    
    func setToggleBtnUI(btn: UIButton) {
        var btnConfig = UIButton.Configuration.plain()
        btnConfig.cornerStyle = .capsule
        btnConfig.image = UIImage(systemName: "list.number")
        btnConfig.imagePadding = 3
        btnConfig.title = toggleButtonState.title
        btnConfig.image?.withTintColor(.black)
        btnConfig.baseBackgroundColor = .white
        toggleButton.configuration = btnConfig
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.title = self.toggleButtonState.title
            case .selected:
                button.configuration?.title = self.toggleButtonState.title
            default:
                return
            }
        }
        toggleButton.configurationUpdateHandler = buttonStateHandler
        
        toggleButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
            $0.layer.borderWidth = 0.6
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.tintColor = .black
            $0.isEnabled = false
        }
        toggleButton.isHidden = true
    }
    
}
