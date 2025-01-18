//
//  UITextField+Extension.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

extension UITextField {
    
    func setTextField(font: UIFont, placeholder: String, textAlignment: NSTextAlignment, backgroundColor: UIColor) {
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.font = font
        self.backgroundColor = backgroundColor
    }
    
}
