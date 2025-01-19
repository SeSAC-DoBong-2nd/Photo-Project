//
//  PhotoTopicViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

final class PhotoTopicViewController: BaseViewController {
    
    private let topicSectionCount = 3
    private let topicListFixedCount = 10
    private let page = 1
    private let perpage = 10
    
    
    private let mainView = PhotoTopicView()
    
    private var topicHeaderTitleArr: [String] = ["", "", ""]
    private lazy var horizontalSections: [[PhotoTopicResponseModel]] = [[], [], []] {
        didSet {
            mainView.topicCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavUI()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPhotoTopic()
    }
    
    override func setHierarchy() {}
    
    override func setLayout() {}
    
    override func setStyle() {
    }

}

private extension PhotoTopicViewController {
    
    func setNavUI() {
        let navRightItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"),
                                          style: .done,
                                          target: self,
                                          action: #selector(navRightBtnTapped))
        navRightItem.tintColor = .black
        navigationItem.rightBarButtonItem = navRightItem
    }
    
    func setDelegate() {
        mainView.topicCollectionView.delegate = self
        mainView.topicCollectionView.dataSource = self
        mainView.topicCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier)
        mainView.topicCollectionView.register(PhotoTopicCollectionHeaderView.self, forSupplementaryViewOfKind: PhotoTopicCollectionHeaderView.elementKinds, withReuseIdentifier: PhotoTopicCollectionHeaderView.identifier)
    }
    
    func getPhotoTopic() {
        var topicIDTypeSet = Set<TopicIDType>()
        while topicIDTypeSet.count < 3 {
            topicIDTypeSet.insert(TopicIDType.allCases.randomElement() ?? TopicIDType.goldenHour)
        }
        let topicIDArr = Array(topicIDTypeSet)
        
        for i in 0..<topicIDArr.count {
            NetworkManager.shared.getPhotoTopicAPI(topicID: topicIDArr[i].rawValue) { result, statusCode in
                switch statusCode {
                case (200..<299):
                    print("!!!", result)
                    self.topicHeaderTitleArr[i] = topicIDArr[i].title
                    for j in result {
                        self.horizontalSections[i].append(j)
                    }
                    
                default:
                    return print("getPhotoSearch Error")
                }
            }
        }
        
        
    }
    
}

private extension PhotoTopicViewController {
    
    @objc
    func navRightBtnTapped() {
        print(#function)
    }
    
}

extension PhotoTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let item = horizontalSections[indexPath.section][indexPath.item]
        let imageID = item.id
        
        NetworkManager.shared.getPhotoDetailAPI(imageID: imageID) {
            result,
            statusCode in
            switch statusCode {
            case (200..<299):
                print("result : \n", result)
                let profileImageURL = item.user.profile_image.medium
                let profileName = item.user.name
                let createAt = item.createdAt
                let selectedImageURL = item.urls.raw
                let selectedImageWidth = item.width
                let selectedImageHeight = item.height
                let downloadCount = result.downloads.historical.change
                let viewCount = result.views.historical.change
                
                let vc = PhotoDetailViewController()
                vc.photoDetailModel = PhotoDetailModel(profileImageURL: profileImageURL,
                                                       profileName: profileName,
                                                       createAt: createAt,
                                                       selectedImageURL: selectedImageURL,
                                                       selectedImageWidth: selectedImageWidth,
                                                       selectedImageHeight: selectedImageHeight,
                                                       downloadCount: downloadCount,
                                                       viewCount: viewCount)
                
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                return print("getPhotoSearch Error")
            }
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return horizontalSections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: PhotoTopicCollectionHeaderView.identifier,
                                                                           for: indexPath) as? PhotoTopicCollectionHeaderView
        else { return UICollectionReusableView() }
        header.setTitle(title: topicHeaderTitleArr[indexPath.section])
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? SearchResultCollectionViewCell
        else { return UICollectionViewCell() }
        
        let item = horizontalSections[indexPath.section][indexPath.item]
        
        cell.configureCellInTopic(image: item.urls.raw, likes: item.likes)
        
        return cell
    }
    
}
