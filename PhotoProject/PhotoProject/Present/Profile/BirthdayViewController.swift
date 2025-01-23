//
//  BirthdayViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//


import UIKit

import SnapKit

final class BirthdayViewController: BaseViewController {

    var onChange: ((String) -> Void)?
    
    private let datePicker = UIDatePicker()
    
    override func setHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func setLayout() {
        datePicker.snp.makeConstraints {
            $0.centerX.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setStyle() {
        navigationItem.title = "생일"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okButtonTapped))
        view.backgroundColor = .white
        
        let birthday = DateFormatterManager.shard.setDateStringFromString(date: UserDefaultsManager.shared.birthday, format: "yyyy-MM-dd")
        
        datePicker.do {
            $0.preferredDatePickerStyle = .wheels
            $0.datePickerMode = .date
            $0.setDate(birthday, animated: true)
        }
    }
    
    @objc
    private func okButtonTapped() {
        print(#function)
        
        let birthday = DateFormatterManager.shard.setDateStringFromDate(date: datePicker.date, format: "yyyy-MM-dd")
        UserDefaultsManager.shared.birthday = birthday
        
        onChange?(birthday)
        
        navigationController?.popViewController(animated: true)
    }
    
}
