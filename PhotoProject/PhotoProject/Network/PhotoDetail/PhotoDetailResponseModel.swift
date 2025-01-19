//
//  PhotoDetailResponseModel.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

struct PhotoDetailResponseModel: Codable {
    let id, slug: String
    let downloads, views, likes: Downloads
}

// MARK: - Downloads
struct Downloads: Codable {
    let total: Int
    let historical: Historical
}

// MARK: - Historical
struct Historical: Codable {
    let change: Int
    let resolution: String
    let quantity: Int
    let values: [Value]
}

// MARK: - Value
struct Value: Codable {
    let date: String
    let value: Int
}
