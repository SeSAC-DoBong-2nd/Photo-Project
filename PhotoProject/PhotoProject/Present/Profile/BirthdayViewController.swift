//
//  BirthdayViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//


import UIKit

import SnapKit

final class BirthdayViewController: BaseViewController {

    private let datePicker = UIDatePicker()
    var onChange: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        let birthday = DateFormatterManager.shard.setDateStringFromString(date: UserDefaultsManager.shared.birthday, format: "yyyy-MM-dd")
        
        datePicker.setDate(birthday, animated: true)
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
