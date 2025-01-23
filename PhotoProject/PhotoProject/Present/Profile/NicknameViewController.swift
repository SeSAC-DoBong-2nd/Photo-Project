//
//  NicknameViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import UIKit
import SnapKit

final class NicknameViewController: BaseViewController {

    private let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setHierarchy() {
        view.addSubview(textField)
    }
    
    override func setLayout() {
        textField.snp.makeConstraints {
            $0.centerX.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func setStyle() {
        navigationItem.title = "닉네임"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        
        view.backgroundColor = .white
        
        textField.placeholder = "닉네임을 입력해주세요"
        textField.text = UserDefaultsManager.shared.nickname
    }
    
    @objc
    private func okButtonTapped() {
        print(#function)
        
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print(text, "text.count")
        
        switch text.count >= 2 {
        case true:
            UserDefaultsManager.shared.nickname = text
            NotificationCenter.default.post(name: NSNotification.Name("nickname"),
                                            object: nil,
                                            userInfo: ["value": text])
            
            navigationController?.popViewController(animated: true)
        case false:
            let alert = UIAlertManager.showAlert(title: "닉네임 등록 실패", message: "2글자 이상 입력해주세요")
            present(alert, animated: true)
        }
    }
    
}
