//
//  LevelViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import UIKit
import SnapKit

class LevelViewController: BaseViewController {

    let segmentedControl = UISegmentedControl(items: ["상", "중", "하"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setHierarchy() {
        view.addSubview(segmentedControl)
    }
    
    override func setLayout() {
        segmentedControl.snp.makeConstraints {
            $0.centerX.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func setStyle() {
        navigationItem.title = "레벨"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        view.backgroundColor = .white
        
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc
    private func okButtonTapped() {
        
    }
}
