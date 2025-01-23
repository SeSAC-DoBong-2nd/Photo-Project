//
//  PhotoSearchViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

import Alamofire

final class PhotoSearchViewController: BaseViewController {
    
    //MARK: - Property
    private let perPage = 20
    private var page = 1
    private var searchText: String? = nil
    private lazy var orderBy = mainView.toggleButtonState.rawValue
    private var selectedColorFilterBtn: String? = nil
    private var isEnd = false
    private var scrollViewDidScrollCnt = 0
    private var searchList: [Result] = [] {
        didSet {
            mainView.searchCollectionView.reloadData()
        }
    }
    
    //MARK: - UI Property
    private let mainView = PhotoSearchView()
    
    override func loadView() {
        view = mainView
        setChildrenViewLayout(view: mainView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchController()
        setDelegate()
        setAddTarget()
    }
    
    override func setStyle() {
        navigationItem.title = "SEARCH PHOTO"
    }
    

}

//MARK: - private extension
private extension PhotoSearchViewController {
    
    func setDelegate() {
        mainView.searchCollectionView.delegate = self
        mainView.searchCollectionView.dataSource = self
        
        mainView.searchCollectionView.prefetchDataSource = self
    }
    
    func setAddTarget() {
        for i in 0..<mainView.colorFilterBtnArr.count {
            mainView.colorFilterBtnArr[i].addTarget(self,
                                                    action: #selector(tappedBtn),
                                                    for: .touchUpInside)
        }
        mainView.toggleButton.addTarget(self,
                                        action: #selector(toggleBtnTapped),
                                        for: .touchUpInside)
    }
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "키워드 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setScrollToTop() {
        mainView.searchCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    func resetSearchListWithPage() {
        searchList.removeAll()
        page = 1
    }
    
    func photoDetailModelDataSet(item: Result, result: PhotoDetailResponseModel) -> PhotoDetailModel {
        let profileImageURL = item.user.profile_image.medium
        let profileName = item.user.name
        let createAt = item.created_at
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
        
        let setPhotoDetailModel = PhotoDetailModel(profileImageURL: profileImageURL,
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
        
        return setPhotoDetailModel
    }
    
    func getPhotoSearchData(query: String, page: Int, perPage: Int, orderBy: String, color: String? = nil) {
        NetworkManager.shared.getUnsplashAPIWithMetaType(
            apiHandler: .getPhotoSearch(query: query,
                                        page: page,
                                        perPage: perPage,
                                        orderBy: orderBy,
                                        color: color),
            responseModel: PhotoSearchResponseModel.self) { result, networkResultType in
                switch networkResultType {
                case .success:
                    print("networkResultType : Success")
                    self.searchList.append(contentsOf: result.results)
                    self.mainView.searchResultState = (self.searchList.count != 0) ? .some : .none
                    self.mainView.searchResultState(state: self.mainView.searchResultState)
                    if !self.searchList.isEmpty && (self.page == 1) {
                        self.mainView.setBtnAbled()
                        self.setScrollToTop()
                    }
                    
                    //호출 오버 방지
                    if result.total - (page * perPage) < 0 {
                        self.isEnd = true
                    }
                case .badRequest, .unauthorized, .forbidden, .notFound, .serverError, .anotherError:
                    let alert = networkResultType.alert
                    self.present(alert, animated: true)
                }
            }
    }
    
}

//MARK: - @objc private extension
private extension PhotoSearchViewController {
    
    @objc
    func tappedBtn(_ sender: UIButton) {
        for i in mainView.colorFilterBtnArr {
            if i == sender {
                guard let text = i.titleLabel?.text else { return }
                for j in PhotoSearchColorButtonType.allCases {
                    if j.rawValue == text {
                        i.isSelected = true
                        selectedColorFilterBtn = j.buttonTitle
                    }
                }
            } else {
                i.isSelected = false
            }
        }
        
        resetSearchListWithPage()
        
        getPhotoSearchData(query: searchText ?? "", page: page, perPage: perPage, orderBy: orderBy, color: selectedColorFilterBtn)
    }
    
    //toggle 버튼 눌린 이후 2초 뒤 hidden 처리
    @objc
    func toggleBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        mainView.toggleButtonState = sender.isSelected ? .latest : .relevant
        orderBy = mainView.toggleButtonState.rawValue
        
        resetSearchListWithPage()
        
        //color filter가 눌려있다면 color 조건 역시 들어가야하니 selectedColorFilterBtn 변수 사용
        getPhotoSearchData(query: searchText ?? "",
                       page: page,
                       perPage: perPage,
                       orderBy: orderBy,
                       color: selectedColorFilterBtn)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.mainView.toggleButton.isHidden = true
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension PhotoSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        //공백 방지
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if text.count < 2 {
            let alert = UIAlertManager.showAlert(title: "조회 실패", message: "2글자 이상 입력해주세요")
            present(alert, animated: true)
        } else  {
            if text != searchText {
                searchText = text
                page = 1
                getPhotoSearchData(query: text, page: page, perPage: perPage, orderBy: orderBy)
            } else {
                print("같은 검색어 입력 방지")
            }
        }
    }
    
}

//MARK: - UIScrollViewDelegate
//스크롤 중 & 스크롤에서 손을 뗀 2초 이후까지 toggleBtn이 보이도록 함
extension PhotoSearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        if scrollViewDidScrollCnt >= 2 {
            DispatchQueue.main.async {
                self.mainView.toggleButton.isHidden = false
            }
        }
            
        scrollViewDidScrollCnt += 1
    }
    
    //스크롤 손가락을 떼었을 때
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.mainView.toggleButton.isHidden = true
        }
    }
    
}

//MARK: - UICollectionViewDataSourcePrefetching
extension PhotoSearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if (searchList.count - 6) == i.item && isEnd == false  {
                page += 1
                
                //color filter가 눌려있다면 color 조건 역시 들어가야하니 selectedColorFilterBtn 변수 사용
                getPhotoSearchData(query: searchText ?? "",
                               page: page,
                               perPage: perPage,
                               orderBy: orderBy,
                               color: selectedColorFilterBtn)
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier, for: indexPath) as! SearchResultCollectionViewCell
        let row = searchList[indexPath.item]
        
        cell.configureCell(image: row.urls.thumb, likes: row.likes)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let item = searchList[indexPath.item]
        let imageID = item.id
        
        NetworkManager.shared.getUnsplashAPIWithMetaType(apiHandler: .getPhotoDetail(imageID: imageID), responseModel: PhotoDetailResponseModel.self) { result, networkResultType in
            switch networkResultType {
            case .success:
                print("networkResultType: success")
                
                let vc = PhotoDetailViewController()
                vc.photoDetailModel = self.photoDetailModelDataSet(item: item, result: result)
                self.viewTransition(viewController: vc, transitionStyle: .push)
            case .badRequest, .unauthorized, .forbidden, .notFound, .serverError, .anotherError:
                let alert = networkResultType.alert
                self.present(alert, animated: true)
            }
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
}



/*
 1. viewDidLoad까지 toggleisHidden = true를 했는데 첫화면에 무조건 toggleBtn이 보이는 중이다. 왜 그러지
- 해결
    - UIScrollViewDelegate scrollViewDidScroll이 viewDidLoad 시 자동으로 불리게 되는 것을 생각하지 못했다.
    - 그 안에 isHidden = False 코드가 있어 그랬던 것.
 */
