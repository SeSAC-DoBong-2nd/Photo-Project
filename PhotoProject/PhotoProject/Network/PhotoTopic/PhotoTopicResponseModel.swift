//
//  PhotoTopicResponseModel.swift
//  PhotoProject
//
//  Created by 박신영 on 1/20/25.
//

import Foundation

struct PhotoTopicResponseModel: Decodable {
    let id: String
    let createdAt: String
    let width, height: Int
    let urls: Urls
    let likes: Int
    let likedByUser: Bool
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case urls, likes
        case likedByUser = "liked_by_user"
        case user
    }
}
