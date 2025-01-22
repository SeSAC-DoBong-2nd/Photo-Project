//
//  UnsplahTargetType.swift
//  PhotoProject
//
//  Created by 박신영 on 1/21/25.
//

import Foundation

import Alamofire

enum UnsplashTargetType {
    
    case getPhotoSearch(query: String, page: Int, perPage: Int, orderBy: String, color: String?)
    case getPhotoDetail(imageID: String)
    case getPhotoTopic(topicID: String)
    
}

extension UnsplashTargetType {
    
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var endPoint: URL {
        switch self {
        case .getPhotoSearch:
            guard let url = URL(string: baseURL + "search/photos")
            else { return URL(fileURLWithPath: "") }
            
            return url
        case .getPhotoDetail(imageID: let imageID):
            guard let url = URL(string: baseURL + "photos/\(imageID)/statistics")
            else { return URL(fileURLWithPath: "") }
            
            return url
        case .getPhotoTopic(topicID: let topicID):
            guard let url = URL(string: baseURL + "topics/\(topicID)/photos")
            else { return URL(fileURLWithPath: "") }
            
            return url
        }
    }
    
    //추후 모든 case 경우로 변환
    var parameter: Parameters {
        switch self {
        case .getPhotoSearch(let query, let page, let perPage, let orderBy, let color):
            if color == nil {
                return ["query": query, "page": page, "per_page": perPage, "order_by": orderBy]
            } else {
                guard let color else {return Parameters()}
                return ["query": query, "page": page, "per_page": perPage, "order_by": orderBy, "color": color]
            }
        case .getPhotoDetail, .getPhotoTopic:
            return Parameters()
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPhotoSearch, .getPhotoDetail, .getPhotoTopic:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        guard let clientID = Bundle.main.client_id
        else { return HTTPHeaders() }
        
        return ["Authorization": "Client-ID \(clientID)"]
    }
    
}
