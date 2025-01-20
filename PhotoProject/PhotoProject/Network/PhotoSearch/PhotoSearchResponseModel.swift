//
//  PhotoSearchResponseModel.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

// MARK: - PhotoSearchResponseModel
struct PhotoSearchResponseModel: Decodable {
    let total, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Result: Decodable {
    let id, created_at: String
    let width, height: Int
    let color: String
    let urls: Urls
    let likes: Int
    let user: User
}

// MARK: - Urls
struct Urls: Decodable {
    let raw, small, thumb, regular: String
}

// MARK: - User
struct User: Decodable {
    let name: String
    let profile_image: ProfileImage
}

// MARK: - ProfileImage
struct ProfileImage: Decodable {
    let medium: String
}
