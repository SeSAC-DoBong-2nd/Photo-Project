//
//  PhotoDetailView.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import UIKit

import SnapKit
import Then

final class PhotoDetailView: BaseView {
    
    private let underLineView = UIView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileContainerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let creatAtLabel = UILabel()
    private let heartBtn = UIButton()
    
    private let mainPosterImage = UIImageView()
    private let infoContainerView = UIView()
    private let infoLabel = UILabel()
    private let sizeLabel = UILabel()
    private let sizeNumLabel = UILabel()
    private let viewLabel = UILabel()
    private let viewNumLabel = UILabel()
    private let downloadLabel = UILabel()
    private let downloadNumLabel = UILabel()
    
    private let chartLabel = UILabel()
    let chartSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["조회", "다운로드"])
        return control
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setHierarchy() {
        addSubviews(underLineView, scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(profileContainerView,
                                heartBtn,
                                mainPosterImage,
                                infoContainerView)
        
        profileContainerView.addSubviews(profileImageView,
                                         nameLabel,
                                         creatAtLabel)
        
        infoContainerView.addSubviews(infoLabel,
                                      sizeLabel,
                                      sizeNumLabel,
                                      viewLabel,
                                      viewNumLabel,
                                      downloadLabel,
                                      downloadNumLabel,
                                      chartLabel,
                                      chartSegmentedControl)
    }
    
    override func setLayout() {
        underLineView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.6)
        }
        
        scrollView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(underLineView.snp.bottom).offset(2)
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.verticalEdges.equalTo(scrollView)
        }
        
        profileContainerView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(15)
            $0.width.greaterThanOrEqualTo(40)
            $0.height.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(35)
        }
        
        creatAtLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(creatAtLabel.snp.leading)
            $0.bottom.equalTo(creatAtLabel.snp.top).offset(-2)
            $0.trailing.equalTo(creatAtLabel.snp.trailing)
        }
        
        heartBtn.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-15)
            $0.width.equalTo(30)
            $0.height.equalTo(28)
        }
        
        mainPosterImage.snp.makeConstraints {
            $0.top.equalTo(profileContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(mainPosterImage.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(15)
            //            $0.height.greaterThanOrEqualTo(40)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        sizeLabel.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.bottom)
            $0.leading.equalTo(infoLabel.snp.trailing)
        }
        
        sizeNumLabel.snp.makeConstraints {
            $0.bottom.equalTo(sizeLabel.snp.bottom)
            $0.trailing.equalToSuperview()
        }
        
        viewLabel.snp.makeConstraints {
            $0.top.equalTo(sizeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(sizeLabel.snp.leading)
        }
        
        viewNumLabel.snp.makeConstraints {
            $0.bottom.equalTo(viewLabel.snp.bottom)
            $0.trailing.equalToSuperview()
        }
        
        downloadLabel.snp.makeConstraints {
            $0.top.equalTo(viewLabel.snp.bottom).offset(10)
            $0.leading.equalTo(sizeLabel.snp.leading)
        }
        
        downloadNumLabel.snp.makeConstraints {
            $0.bottom.equalTo(downloadLabel.snp.bottom)
            $0.trailing.equalToSuperview()
        }
        
        chartLabel.snp.makeConstraints {
            $0.top.equalTo(downloadLabel.snp.bottom).offset(50)
            $0.leading.equalTo(infoLabel.snp.leading)
        }
        
        chartSegmentedControl.snp.makeConstraints {
            $0.leading.equalTo(sizeLabel.snp.leading)
            $0.bottom.equalTo(chartLabel.snp.bottom)
        }
        
    }
    
    override func setStyle() {
        underLineView.backgroundColor = .lightGray
        
        profileImageView.do {
            $0.image = UIImage(systemName: "star")
            $0.layer.cornerRadius = 40/2
            $0.contentMode = .scaleAspectFill
        }
        
        nameLabel.setLabelUI("name", font: .systemFont(ofSize: 16, weight: .light))
        
        creatAtLabel.setLabelUI("2888년 8월 8일 게시됨", font: .systemFont(ofSize: 12, weight: .medium))
        
        heartBtn.do {
            $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            $0.backgroundColor = .clear
            $0.imageView?.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        mainPosterImage.do {
            $0.image = UIImage(systemName: "person")
            $0.contentMode = .scaleAspectFill
        }
        
        infoLabel.setLabelUI("정보", font: .systemFont(ofSize: 18, weight: .heavy))
        
        sizeLabel.setLabelUI("크기", font: .systemFont(ofSize: 14, weight: .bold))
        viewLabel.setLabelUI("조회수", font: .systemFont(ofSize: 14, weight: .bold))
        downloadLabel.setLabelUI("다운로드", font: .systemFont(ofSize: 14, weight: .bold))
        
        sizeNumLabel.setLabelUI("3000 x 3999", font: .systemFont(ofSize: 12, weight: .light))
        viewNumLabel.setLabelUI(214912894.formatted(), font: .systemFont(ofSize: 12, weight: .light))
        downloadNumLabel.setLabelUI(12481294.formatted(), font: .systemFont(ofSize: 12, weight: .light))
        
        chartLabel.setLabelUI("차트", font: .systemFont(ofSize: 18, weight: .heavy))
        
        chartSegmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.isEnabled = true
            $0.isUserInteractionEnabled = true
        }
    }
    
    func setDataUI(photoDetailModel: PhotoDetailModel) {
        mainPosterImage.setImageKfDownSampling(with: photoDetailModel.selectedImageURL, cornerRadius: 0)
        profileImageView.setImageKfDownSampling(with: photoDetailModel.profileImageURL, cornerRadius: 40/2)
        nameLabel.text = photoDetailModel.profileName
        creatAtLabel.text = photoDetailModel.createAt
        sizeNumLabel.text = "\(photoDetailModel.selectedImageWidth) x \(photoDetailModel.selectedImageHeight)"
        viewNumLabel.text = photoDetailModel.viewCount.formatted()
        downloadNumLabel.text = photoDetailModel.downloadCount.formatted()
        
    }
    
}



/*
 1. line 94에 아래와 같은 코드를 사용하면 왜 레이아웃 에러가 날까
 profileContainerView.snp.makeConstraints {
     $0.top.equalTo(underLineView.snp.bottom).offset(2)
     $0.leading.equalToSuperview().offset(15)
     $0.trailing.lessThanOrEqualTo(heartBtn.snp.leading).offset(-10)
     $0.height.equalTo(50)
 }
 2. 아래 레이아웃 에러가 왜 나는지 모르겠다..
 (
     "<SnapKit.LayoutConstraint:0x600002606a00@PhotoDetailView.swift#78 UIView:0x101d05320.top == UILayoutGuide:0x600003b089a0.top>",
     "<SnapKit.LayoutConstraint:0x6000026055c0@PhotoDetailView.swift#85 UIScrollView:0x103009e00.top == UIView:0x101d05320.bottom + 2.0>",
     "<SnapKit.LayoutConstraint:0x6000026056e0@PhotoDetailView.swift#86 UIScrollView:0x103009e00.bottom == PhotoProject.PhotoDetailView:0x101d050e0.bottom>",
     "<NSLayoutConstraint:0x600002131c20 '_UITemporaryLayoutHeight' PhotoProject.PhotoDetailView:0x101d050e0.height == 0   (active)>",
     "<NSLayoutConstraint:0x600002138370 'UIViewSafeAreaLayoutGuide-top' V:|-(0)-[UILayoutGuide:0x600003b089a0'UIViewSafeAreaLayoutGuide']   (active, names: '|':PhotoProject.PhotoDetailView:0x101d050e0 )>"
 )
 3. view안에 label들로만 채운다면 view snp 설정할 때 height을 주지않아도 알아서 계산으로 들어가는데, 그 view의 bottom을 기준으로 다른 프로퍼티의 top을 잡으니 레이아웃이 원하는대로 되지않는다. 뷰가 그려지는 사이클이 꼬여서 그런거 같은데, 이걸 해결할 수 있는 방법이 있을까
 4. segmentControl이 왜 안 눌리는가..
 */
