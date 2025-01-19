//
//  PhotoSearchViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

import Alamofire

final class PhotoSearchViewController: BaseViewController {
    
    private let perPage = 20
    private var page = 1
    private var searchText: String? = nil
    private lazy var orderBy = mainView.toggleButtonState.rawValue
    private var selectedColorFilterBtn: String? = nil
    private var isEnd = false
    
    let dummyData = DummyDataGenerator.generateDummyData()
    private var searchList: [Result] = [] {
        didSet {
            mainView.searchCollectionView.reloadData()
        }
    }
    
    let mainView = PhotoSearchView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchController()
        setDelegate()
        setAddTarget()
        
        mainView.toggleButton.isHidden = true
    }
    
    override func setHierarchy() {}
    
    override func setLayout() {}
    
    override func setStyle() {
        navigationItem.title = "SEARCH PHOTO"
    }
    

}

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
        mainView.toggleButton.addTarget(self, action: #selector(toggleBtnTapped), for: .touchUpInside)
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
    
    func getPhotoSearch(query: String, page: Int, perPage: Int, orderBy: String, color: String? = nil) {
        print(perPage)
        NetworkManager.shared.getPhotoSearchAPI(query: query, page: page, perPage: perPage, orderBy: orderBy, color: color) { result,statusCode  in
            switch statusCode {
            case (200..<299):
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
                
            default:
                return print("getPhotoSearch Error")
            }
        }
    }
    
}

private extension PhotoSearchViewController {
    
    @objc
    func tappedBtn(_ sender: UIButton) {
        for i in mainView.colorFilterBtnArr {
            if i == sender {
                guard let text = i.titleLabel?.text else { return }
                for j in PhotoSearchColorButton.allCases {
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
        
        getPhotoSearch(query: searchText ?? "", page: page, perPage: perPage, orderBy: orderBy, color: selectedColorFilterBtn)
    }
    
    //toggle 버튼 눌린 이후 2초 뒤 hidden 처리
    @objc
    func toggleBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.mainView.toggleButtonState = sender.isSelected ? .latest : .relevant
        
        resetSearchListWithPage()
        
        self.getPhotoSearch(query: self.searchText ?? "",
                            page: self.page,
                            perPage: self.perPage,
                            orderBy: orderBy)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.mainView.toggleButton.isHidden = true
        }
    }
    
}

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
                getPhotoSearch(query: text, page: page, perPage: perPage, orderBy: orderBy)
            } else {
                print("같은 검색어 입력 방지")
            }
        }
    }
    
}

//스크롤 중 & 스크롤에서 손을 뗀 2초 이후까지 toggleBtn이 보이도록 함
extension PhotoSearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        DispatchQueue.main.async {
            self.mainView.toggleButton.isHidden = false
        }
    }
    
    //스크롤 손가락을 떼었을 때
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.mainView.toggleButton.isHidden = true
        }
    }
    
}

extension PhotoSearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function, indexPaths)
        
        for i in indexPaths {
            if (searchList.count - 6) == i.item && isEnd == false  {
                page += 1
                
                //color filter가 눌려있다면 color 조건 역시 들어가야하니 selectedColorFilterBtn 변수 사용
                getPhotoSearch(query: searchText ?? "",
                               page: page,
                               perPage: perPage,
                               orderBy: orderBy,
                               color: selectedColorFilterBtn)
            }
        }
    }
    
}

extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        print("self.searchList.count \(self.searchList.count)")
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier, for: indexPath) as! SearchResultCollectionViewCell
        let row = searchList[indexPath.item]
        
        cell.configureCell(image: row.urls.raw, likes: row.likes)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let imageID = searchList[indexPath.item].id
        NetworkManager.shared.getPhotoDetailAPI(imageID: imageID) { result, statusCode in
            switch statusCode {
            case (200..<299):
                print("result : \n", result)
                
            default:
                return print("getPhotoSearch Error")
            }
        }
    }
    
}



/*
 1. viewDidLoad까지 toggleisHidden = true를 했는데 첫화면에 무조건 toggleBtn이 보이는 중이다. 왜 그러지
 */
