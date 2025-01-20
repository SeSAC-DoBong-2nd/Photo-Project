//
//  PhotoDetailModel.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

struct PhotoDetailModel {
    let profileImageURL: String
    let profileName: String
    let createAt: String
    let selectedImageURL: String
    let selectedImageWidth, selectedImageHeight: Int
    let downloadCount: Int
    let viewCount: Int
    let day30ViewCount: [Int]
    let day30DownCount: [Int]
}
