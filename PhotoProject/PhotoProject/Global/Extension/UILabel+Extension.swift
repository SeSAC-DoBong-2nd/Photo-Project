//
//  UILabel+Extension.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

extension UILabel {
    
    func setPrimaryLabel(_ text: String) {
        self.text = text
        self.font = .systemFont(ofSize: 14, weight: .medium)
        self.textColor = .black
        self.textAlignment = .left
    }
    
    func setLabelUI(_ text: String,
                    font: UIFont,
                    textColor: UIColor = .black,
                    alignment: NSTextAlignment = .left,
                    numberOfLines: Int = 1)
    {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }
    
}

