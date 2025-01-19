//
//  PhotoSearchColorButton.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

enum PhotoSearchColorButton: String, CaseIterable {
    case black = "블랙"
    case white = "화이트"
    case yellow = "옐로우"
    case red = "레드"
    case purple = "퍼플"
    case green = "그린"
    case blue = "블루"
    case empty = "              "
    
    var buttonTitle: String {
        switch self {
        case .black:
            return "black"
        case .white:
            return "white"
        case .yellow:
            return "yellow"
        case .red:
            return "red"
        case .purple:
            return "purple"
        case .green:
            return "green"
        case .blue:
            return "blue"
        case .empty:
            return ""
        }
    }
    
    var buttonimageColor: UIColor {
        switch self {
        case .black:
            return .black
        case .white:
            return .white
        case .yellow:
            return .systemYellow
        case .red:
            return .systemRed
        case .purple:
            return .systemPurple
        case .green:
            return .systemGreen
        case .blue:
            return .blue
        case .empty:
            return .clear
        }
    }
}
