//
//  PhotoSearchViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

final class PhotoSearchViewController: BaseViewController {
    
    let dummyData = DummyDataGenerator.generateDummyData()
    let mainView = PhotoSearchView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchController()
        setDelegate()
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
    }
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "키워드 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension PhotoSearchViewController: UISearchBarDelegate {
    
}

extension PhotoSearchViewController: UICollectionViewDelegate {
    
}

extension PhotoSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return dummyData.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier, for: indexPath) as! SearchResultCollectionViewCell
        
        cell.configureCell(image: dummyData.results[0].urls.raw)
        
        return cell
    }
    
    
}
