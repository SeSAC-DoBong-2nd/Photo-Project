//
//  ProfileViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {

    let nicknameButton = UIButton()
    let birthdayButton = UIButton()
    let levelButton = UIButton()
    
    let nicknameLabel = UILabel()
    let birthdayLabel = UILabel()
    let levelLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setHierarchy() {
        view.addSubviews(nicknameButton,
                         birthdayButton,
                         levelButton,
                         nicknameLabel,
                         birthdayLabel,
                         levelLabel)
    }
    
    override func setLayout() {
        nicknameButton.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
        
        birthdayButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.top.equalTo(nicknameButton.snp.bottom).offset(24)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }

        levelButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.top.equalTo(birthdayButton.snp.bottom).offset(24)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(nicknameButton.snp.trailing).offset(24)
            $0.height.equalTo(50)
        }
        
        birthdayLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(birthdayButton.snp.trailing).offset(24)
            $0.height.equalTo(50)
        }

        levelLabel.snp.makeConstraints {
            $0.top.equalTo(birthdayLabel.snp.bottom).offset(24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(levelButton.snp.trailing).offset(24)
            $0.height.equalTo(50)
        }

    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        navigationItem.title = "프로필 화면"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "탈퇴하기",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(unSignButtonTapped))
        
        nicknameButton.setTitleColor(.black, for: .normal)
        birthdayButton.setTitleColor(.black, for: .normal)
        levelButton.setTitleColor(.black, for: .normal)
        
        nicknameButton.setTitle("닉네임", for: .normal)
        birthdayButton.setTitle("생일", for: .normal)
        levelButton.setTitle("레벨", for: .normal)

        nicknameLabel.text = "NO NAME"
        nicknameLabel.textColor = .lightGray
        nicknameLabel.textAlignment = .right
        
        birthdayLabel.text = "NO DATE"
        birthdayLabel.textColor = .lightGray
        birthdayLabel.textAlignment = .right
        
        levelLabel.text = "NO LEVEL"
        levelLabel.textColor = .lightGray
        levelLabel.textAlignment = .right
    }

    @objc
    private func unSignButtonTapped() {
        print(#function)
        
        UserDefaultsManager.shared.isNotFirstLoading = false
        print("UserDefaultsManager.shared.isNotFirstLoading: \(UserDefaultsManager.shared.isNotFirstLoading)")
        
        //rootVC 탭바VC로 변경
        guard let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }

        window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        window.makeKeyAndVisible()
    }
    
}
