//
//  LevelViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import UIKit

import SnapKit

final class LevelViewController: BaseViewController {

    var delegate: LevelDelegateProtocol?
    
    private let segmentedControl = UISegmentedControl(items: ["상", "중", "하"])
    
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
        view.backgroundColor = .white
        
        navigationItem.title = "레벨"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        
        switch UserDefaultsManager.shared.level {
        case "상":
            return segmentedControl.selectedSegmentIndex = 0
        case "중":
            return segmentedControl.selectedSegmentIndex = 1
        case "하":
            return segmentedControl.selectedSegmentIndex = 2
        default:
            return segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    @objc
    private func okButtonTapped() {
        let index = segmentedControl.selectedSegmentIndex
        guard let selectedSegTitle = segmentedControl.titleForSegment(at: index)
        else { return }
        
        UserDefaultsManager.shared.level = selectedSegTitle
        
        delegate?.setLevelData(levelTitle: selectedSegTitle)
        
        navigationController?.popViewController(animated: true)
    }
}
