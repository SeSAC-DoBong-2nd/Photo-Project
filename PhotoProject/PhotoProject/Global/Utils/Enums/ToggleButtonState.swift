//
//  ToggleButtonState.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

enum ToggleButtonState: String {
    case relevant = "relevant"
    case latest = "latest"
    
    var title: String {
        switch self {
        case .relevant:
            return "관련순"
        case .latest:
            return "최신순"
        }
    }
}
