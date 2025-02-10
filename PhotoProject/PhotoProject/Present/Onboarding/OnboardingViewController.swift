//
//  OnboardingViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: UIViewController {

    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
 
}

private extension OnboardingViewController {
    
    func setHierarchy() {
        view.addSubview(button)
    }
    
    func setLayout() {
        button.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(50)
        }
    }
    
    func setStyle() {
        view.backgroundColor = .darkGray
        
        button.do {
            $0.layer.cornerRadius = 25
            $0.backgroundColor = .white
            $0.setTitleColor(.darkGray, for: .normal)
            $0.setTitle("시작하기", for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc
    func buttonTapped() {
        UserDefaultsManager.shared.isNotFirstLoading = true
        print("UserDefaultsManager.shared.isNotFirstLoading: \(UserDefaultsManager.shared.isNotFirstLoading)")
        
        //rootVC 탭바VC로 변경
        guard let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }

        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
    
}
