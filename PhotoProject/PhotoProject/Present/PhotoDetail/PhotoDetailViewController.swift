//
//  PhotoDetailViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

class PhotoDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavUI()
    }

    override func setHierarchy() {}
    
    override func setLayout() {}
    
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
    
}

private extension PhotoDetailViewController {
    
    @objc
    func navLeftBtnTapped() {
        
    }
    
}
