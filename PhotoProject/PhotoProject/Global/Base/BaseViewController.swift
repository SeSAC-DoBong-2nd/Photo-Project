//
//  BaseViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {}
    
    func setLayout() {}
    
    func setStyle() {
        view.backgroundColor = .white
    }
    
    func setChildrenViewLayout<T: BaseView>(view: T) {
        view.setLayout()
    }
    
}
