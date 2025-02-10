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
        print(#function)
        view = mainView
        setChildrenViewLayout(view: mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotoTopicData()
        setNavUI()
        setDelegate()
        setRefreshControl()
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
        mainView.topicCollectionView.register(SearchResultCollectionViewCell.self,
                                              forCellWithReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier)
        mainView.topicCollectionView.register(PhotoTopicCollectionHeaderView.self,
                                              forSupplementaryViewOfKind: PhotoTopicCollectionHeaderView.elementKinds,
                                              withReuseIdentifier: PhotoTopicCollectionHeaderView.identifier)
    }
    
    func setRefreshControl () {
        mainView.topicCollectionView.refreshControl = UIRefreshControl()
        mainView.topicCollectionView.refreshControl?.addTarget(self, action:
                                                                #selector(handleRefreshControl),
                                                               for: .valueChanged)
    }
    
    func handlingHistoricalData(historicalData: Historical) -> ([String], [Int], [Int]) {
        let dates = historicalData.values.map {
            DateFormatterManager.shard.setDateString(strDate: $0.date, format: "MM.dd")
        }
        let values = historicalData.values.map { $0.value }
        let totalCount = values
        
        return (dates, values, totalCount)
    }
    
    func photoDetailModelDataSet(item: PhotoTopicResponseModel, result: PhotoDetailResponseModel) -> PhotoDetailModel {
        let profileImageURL = item.user.profile_image.medium
        let profileName = item.user.name
        let createAt = item.createdAt
        let selectedImageURL = item.urls.regular
        let selectedImageWidth = item.width
        let selectedImageHeight = item.height
        let downloadCount = result.downloads.historical.change
        let viewCount = result.views.historical.change

        let (view30Days, view30DaysValue, day30ViewCount) = handlingHistoricalData(historicalData: result.views.historical)
        let (download30Days, download30DaysValue, day30DownCount) = handlingHistoricalData(historicalData: result.downloads.historical)

        let monthView = MonthData(dates: view30Days, values: view30DaysValue)
        let monthDownload = MonthData(dates: download30Days, values: download30DaysValue)

        return PhotoDetailModel(
            profileImageURL: profileImageURL,
            profileName: profileName,
            createAt: createAt,
            selectedImageURL: selectedImageURL,
            selectedImageWidth: selectedImageWidth,
            selectedImageHeight: selectedImageHeight,
            downloadCount: downloadCount,
            viewCount: viewCount,
            monthViewTotalCount: day30ViewCount,
            monthDownloadTotalCount: day30DownCount,
            monthView: monthView,
            monthDownload: monthDownload
        )
    }
    
    func getPhotoTopicData(isRefreshControl: Bool? = false) {
        var topicIDTypeSet = Set<TopicIDType>()
        while topicIDTypeSet.count < 3 {
            topicIDTypeSet.insert(TopicIDType.allCases.randomElement() ?? TopicIDType.goldenHour)
        }
        
        let topicIDArr = Array(topicIDTypeSet)
        let group = DispatchGroup()
        var items: [[PhotoTopicResponseModel]] = [[], [], []]
        for i in 0..<topicIDArr.count {
            group.enter()
            NetworkManager.shared.getUnsplashAPIWithMetaType(apiHandler:.getPhotoTopic(topicID: topicIDArr[i].rawValue), responseModel: [PhotoTopicResponseModel].self) { result, networkResultType in
                switch networkResultType {
                case .success:
                    print("networkResultType : Success")
                    self.topicHeaderTitleArr[i] = topicIDArr[i].title
                    for j in result {
                        items[i].append(j)
                    }
                    group.leave()
                case .badRequest, .unauthorized, .forbidden, .notFound, .serverError, .anotherError:
                    group.leave()
                    let alert = networkResultType.alert
                    self.present(alert, animated: true)
                }
            }
        }
        
        DispatchQueue.main.async {
            group.notify(queue: .main) {
                print("지금 group 끝나서 작업 시작!")
                self.horizontalSections = items

                // RefreshControl 상태에 따라 첫 번째 인덱스로 이동하는 동작 추가
                if isRefreshControl ?? false {
                    for i in 0..<self.horizontalSections.count {
                        self.mainView.topicCollectionView.scrollToItem(at: IndexPath(item: 0, section: i),
                                                                       at: .left,
                                                                       animated: false)
                    }
                }
                print("지금 group 작업 끝!")
                self.mainView.topicCollectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
}

private extension PhotoTopicViewController {
    
    @objc
    func navRightBtnTapped() {
        print(#function)
        let vc = ProfileViewController(nickname: UserDefaultsManager.shared.nickname,
                                       birthday: UserDefaultsManager.shared.birthday,
                                       level: UserDefaultsManager.shared.level)
        
        viewTransition(viewController: vc, transitionStyle: .push)
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

        NetworkManager.shared.getUnsplashAPIWithMetaType(apiHandler: .getPhotoDetail(imageID: imageID), responseModel: PhotoDetailResponseModel.self) { result, networkResultType in
            switch networkResultType {
            case .success:
                print("networkResultType: success")
                let photoDetailModel = self.photoDetailModelDataSet(item: item, result: result)
                let vc = PhotoDetailViewController(viewModel: PhotoDetailViewModel(photoDetailModel: photoDetailModel, isSuccessLoad: true))
                
                self.viewTransition(viewController: vc, transitionStyle: .push)
            case .badRequest, .unauthorized, .forbidden, .notFound, .serverError, .anotherError:
                let alert = networkResultType.alert
                self.present(alert, animated: true)
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
