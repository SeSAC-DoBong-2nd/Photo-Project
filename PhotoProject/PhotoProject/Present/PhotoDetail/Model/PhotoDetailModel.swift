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
    let monthViewTotalCount: [Int]
    let monthDownloadTotalCount: [Int]
    let monthView: MonthView
    let monthDownload: MonthDownload
}

struct MonthView {
    let monthViewDates: [String]
    let monthViewValues: [Int]
}

struct MonthDownload {
    let monthDownloadDates: [String]
    let monthDownloadValues: [Int]
}
