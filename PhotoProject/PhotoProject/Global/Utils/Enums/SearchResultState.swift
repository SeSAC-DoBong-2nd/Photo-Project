//
//  SearchResultState.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

enum SearchResultState {
    case yet
    case none
    
    var title: String {
        switch self {
        case .yet:
            return "사진을 검색해보세요."
        case .none:
            return "검색 결과가 없어요."
        }
    }
    
    var isEmptyViewHidden: Bool {
        switch self {
        case .yet:
            return false
        case .none:
            return true
        }
    }
}
