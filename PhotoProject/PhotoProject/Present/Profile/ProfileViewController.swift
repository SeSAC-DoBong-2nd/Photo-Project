//
//  ProfileViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    let nickname: String
    let birthday: String
    let level: String

    let nicknameButton = UIButton()
    let birthdayButton = UIButton()
    let levelButton = UIButton()
    let saveButton = UIButton()
    
    let nicknameLabel = UILabel()
    let birthdayLabel = UILabel()
    let levelLabel = UILabel()
    
    init(nickname: String, birthday: String, level: String) {
        self.nickname = nickname
        self.birthday = birthday
        self.level = level
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButtonStateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setAddTarget()
    }
    
    override func setHierarchy() {
        view.addSubviews(nicknameButton,
                         birthdayButton,
                         levelButton,
                         nicknameLabel,
                         birthdayLabel,
                         levelLabel,
                         saveButton)
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
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }

    }
    
    override func setStyle() {
        levelLabel.text = level
        nicknameLabel.text = nickname
        birthdayLabel.text = birthday
        
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

        
        nicknameLabel.textColor = .lightGray
        nicknameLabel.textAlignment = .right
        
        birthdayLabel.textColor = .lightGray
        birthdayLabel.textAlignment = .right
        
        levelLabel.textColor = .lightGray
        levelLabel.textAlignment = .right
        
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
    }
    
}

private extension ProfileViewController {
    
    func setAddTarget() {
        nicknameButton.addTarget(self, action: #selector(nicknameButtonTapped), for: .touchUpInside)
        birthdayButton.addTarget(self, action: #selector(birthdayButtonTapped), for: .touchUpInside)
        levelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationOn),
                                               name: NSNotification.Name("nickname"),
                                               object: nil)
    }
    
    func saveButtonStateUI() {
        let name = UserDefaultsManager.shared.nickname
        let birthday = UserDefaultsManager.shared.birthday
        let level = UserDefaultsManager.shared.level
        
        let flag = [name,birthday,level].allSatisfy {
            !["NO NAME", "NO DATE", "NO LEVEL"].contains($0)
        }
        
        saveButton.backgroundColor = flag ? .blue : .lightGray
        let titleColor: UIColor = flag ? .white : .black
        saveButton.setTitleColor(titleColor, for: .normal)
    }
    
    @objc
    func nicknameButtonTapped() {
        print(#function)
        viewTransition(viewController: NicknameViewController(), transitionStyle: .push)
    }
    
    @objc
    func birthdayButtonTapped() {
        print(#function)
        let vc = BirthdayViewController()
        vc.onChange = { birthday in
            self.birthdayLabel.text = birthday
        }
        viewTransition(viewController: vc, transitionStyle: .push)
    }
    
    @objc
    func levelButtonTapped() {
        print(#function)
        let vc = LevelViewController()
        vc.delegate = self
        viewTransition(viewController: vc, transitionStyle: .push)
    }
    
    @objc
    func saveButtonTapped() {
        print(#function)
        
        let alert = UIAlertManager.showAlert(title: "저장 성공", message: "🎉축하합니다🎉")
        present(alert, animated: true)
    }

    @objc
    func unSignButtonTapped() {
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
    
    @objc
    func notificationOn(notification: NSNotification) {
        if let name = notification.userInfo!["value"] as? String {
            nicknameLabel.text = name
        } else {
            nicknameLabel.text = "데이터가 안 왔음"
        }
    }
    
}

extension ProfileViewController: LevelDelegateProtocol {
    
    func setLevelData(levelTitle: String) {
        print(#function)
        levelLabel.text = levelTitle
    }
    
}
