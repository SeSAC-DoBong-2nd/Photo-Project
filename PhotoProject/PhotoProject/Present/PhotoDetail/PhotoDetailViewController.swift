//
//  PhotoDetailViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

final class PhotoDetailViewController: BaseViewController {
    
    let mainView = PhotoDetailView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavUI()
        setAddtarget()
    }

    override func setHierarchy() {}
    
    override func setLayout() {
    }
    
    override func setStyle() {
    }

}

private extension PhotoDetailViewController {
    
    func setNavUI() {
        let navLeftItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                          style: .done,
                                          target: self,
                                          action: #selector(navLeftBtnTapped))
        navLeftItem.tintColor = .black
        navigationItem.leftBarButtonItem = navLeftItem
    }
    
    func setDelegate() {
    }
    
    func setAddtarget() {
        mainView.chartSegmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }
    
}

private extension PhotoDetailViewController {
    
    @objc
    func navLeftBtnTapped() {
        
    }
    
    @objc
    func segmentedControlTapped(_ sender: UISegmentedControl) {
        print(#function)
        sender.selectedSegmentIndex = (sender.selectedSegmentIndex == 0)
        ? 1 : 0
    }
    
}
