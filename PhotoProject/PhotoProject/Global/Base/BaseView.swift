//
//  BaseView.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setLayout() //주석 처리로 부모뷰 layout 잡히기 이전 실행되는 것 방지
        setHierarchy()
        setStyle()
    }
    
    func setHierarchy() {}
    
    func setLayout() {}
    
    func setStyle() {
        self.backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
