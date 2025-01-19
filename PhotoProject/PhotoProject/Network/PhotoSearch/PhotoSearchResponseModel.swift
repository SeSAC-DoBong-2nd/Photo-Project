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
    let raw, small: String
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

struct DummyDataGenerator {
    static func generateDummyData() -> PhotoSearchResponseModel {
        let results = (1...20).map { index in
            Result(
                id: "id_\(index)",
                created_at: "2025-01-19T12:00:00Z",
                width: Int.random(in: 800...4000),
                height: Int.random(in: 800...4000),
                color: ["#FF5733", "#33FF57", "#3357FF", "#F0F0F0", "#000000"].randomElement()!,
                urls: Urls(
                    raw: "star",
                    small: "star"
                ),
                likes: Int.random(in: 0...1000),
                user: User(
                    name: "User \(index)",
                    profile_image: ProfileImage(
                        medium: "star"
                    )
                )
            )
        }
        
        return PhotoSearchResponseModel(
            total: 20,
            totalPages: 1,
            results: results
        )
    }
}
