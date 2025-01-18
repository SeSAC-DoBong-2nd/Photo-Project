//
//  UIStackView+Extension.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
    
}
