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
    case some
    
    var title: String? {
        switch self {
        case .yet:
            return "사진을 검색해보세요."
        case .none:
            return "검색 결과가 없어요."
        case .some:
            return nil
        }
    }
    
    var isEmptyViewHidden: Bool {
        switch self {
        case .yet, .none:
            return false
        case .some:
            return true
        }
    }
}
