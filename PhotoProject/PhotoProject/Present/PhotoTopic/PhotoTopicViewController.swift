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
    private var isRefreshEnabled = true
    
    private var topicHeaderTitleArr: [String] = ["", "", ""]
    private lazy var horizontalSections: [[PhotoTopicResponseModel]] = [[], [], []] {
        didSet {
            mainView.topicCollectionView.reloadData()
        }
    }
    
    private let mainView = PhotoTopicView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotoTopicData()
        setNavUI()
        setDelegate()
        setRefreshControl()
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
    
    func getPhotoTopicData(isRefreshControl: Bool? = false) {
        var topicIDTypeSet = Set<TopicIDType>()
        while topicIDTypeSet.count < 3 {
            topicIDTypeSet.insert(TopicIDType.allCases.randomElement() ?? TopicIDType.goldenHour)
        }
        let topicIDArr = Array(topicIDTypeSet)
        
        for i in 0..<topicIDArr.count {
            NetworkManager.shared.getPhotoTopic(apiHandler:.getPhotoTopic(topicID: topicIDArr[i].rawValue)) { result, statusCode in
                switch statusCode {
                case (200..<299):
                    self.topicHeaderTitleArr[i] = topicIDArr[i].title
                    if (isRefreshControl ?? false) {
                        self.horizontalSections[i].removeAll()
                    }
                    for j in result {
                        self.horizontalSections[i].append(j)
                    }
                    DispatchQueue.main.async {
                        if (isRefreshControl ?? false) {
                            for i in 0..<self.horizontalSections.count {
                                self.mainView.topicCollectionView.scrollToItem(at: IndexPath(item: 0, section: i), at: .left, animated: true)
                            }
                        }
                        self.mainView.topicCollectionView.refreshControl?.endRefreshing()
                    }
                    
                default:
                    return print("getPhotoSearchData Error")
                }
            }
        }
    }
    
    func setRefreshControl () {
        mainView.topicCollectionView.refreshControl = UIRefreshControl()
        mainView.topicCollectionView.refreshControl?.addTarget(self, action:
                                                                #selector(handleRefreshControl),
                                                               for: .valueChanged)
    }
    
}

private extension PhotoTopicViewController {
    
    @objc
    func navRightBtnTapped() {
        print(#function)
    }
    
    @objc
    func handleRefreshControl() {
        guard isRefreshEnabled else {
            mainView.topicCollectionView.refreshControl?.endRefreshing()
            return
        }
        
        // 새로고침 비활성화
        isRefreshEnabled = false
        
        DispatchQueue.main.async {
            self.getPhotoTopicData(isRefreshControl: true)
        }
        
        // 60초 후 다시 새로고침 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.isRefreshEnabled = true
        }
    }
    
}

extension PhotoTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let item = horizontalSections[indexPath.section][indexPath.item]
        let imageID = item.id
        
        NetworkManager.shared.getPhotoDetail(apiHandler: .getPhotoDetail(imageID: imageID)) {
            result,
            statusCode in
            switch statusCode {
            case (200..<299):
                let profileImageURL = item.user.profile_image.medium
                let profileName = item.user.name
                let createAt = item.createdAt
                let selectedImageURL = item.urls.regular
                let selectedImageWidth = item.width
                let selectedImageHeight = item.height
                let downloadCount = result.downloads.historical.change
                let viewCount = result.views.historical.change
                
                var day30ViewCount: [Int] = []
                for i in result.views.historical.values {
                    day30ViewCount.append(i.value)
                }
                var day30DownCount: [Int] = []
                for i in result.downloads.historical.values {
                    day30DownCount.append(i.value)
                }
                var view30Days = [String]()
                for i in result.views.historical.values {
                    print(i.date)
                    view30Days.append(DateFormatterManager.shard.setDateString(strDate: i.date, format: "MM.dd"))
                }
                var view30DaysValue = [Int]()
                for i in result.views.historical.values {
                    view30DaysValue.append(i.value)
                }
                
                var download30Days = [String]()
                for i in result.downloads.historical.values {
                    print(i.date)
                    download30Days.append(DateFormatterManager.shard.setDateString(strDate: i.date, format: "MM.dd"))
                }
                var download30DaysValue = [Int]()
                for i in result.downloads.historical.values {
                    download30DaysValue.append(i.value)
                }
                
                let monthView = MonthView(monthViewDates: view30Days, monthViewValues: view30DaysValue)
                let monthDownload = MonthDownload(monthDownloadDates: download30Days, monthDownloadValues: download30DaysValue)
                
                let vc = PhotoDetailViewController()
                vc.photoDetailModel = PhotoDetailModel(profileImageURL: profileImageURL,
                                                       profileName: profileName,
                                                       createAt: createAt,
                                                       selectedImageURL: selectedImageURL,
                                                       selectedImageWidth: selectedImageWidth,
                                                       selectedImageHeight: selectedImageHeight,
                                                       downloadCount: downloadCount,
                                                       viewCount: viewCount, monthViewTotalCount: day30ViewCount,
                                                       monthDownloadTotalCount: day30ViewCount,
                                                       monthView: monthView,
                                                       monthDownload: monthDownload)
                
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                return print("getPhotoSearchData Error")
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
        
        cell.configureCellInTopic(image: item.urls.thumb, likes: item.likes)
        
        return cell
    }
    
}
