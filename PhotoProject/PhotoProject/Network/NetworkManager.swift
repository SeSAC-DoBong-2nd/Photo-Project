//
//  NetworkManager.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getPhotoSearchAPI(query: String,
                           page: Int,
                           perPage: Int,
                           orderBy: String,
                           color: String? = nil,
                           complitionHandler: @escaping (PhotoSearchResponseModel, Int) -> (Void))
    {
        guard let clientID = Bundle.main.client_id else {return}
        let url = "https://api.unsplash.com/search/photos"
        let method: HTTPMethod = .get
        var parameters: [String: Any] = ["query": query, "page": page, "per_page": perPage, "order_by": orderBy, "client_id": clientID]
        
        
        switch color != nil {
        case true:
            guard let color else { return print("getPhotoSearch error") }
            parameters["color"] = color
        case false:
            print("color = nil")
        }
        
        print("parameters : \(parameters)")
        
        AF.request(url, method: method, parameters: parameters).responseDecodable(of: PhotoSearchResponseModel.self) { response in
            switch response.result {
            case .success(let result):
                print("success")
                complitionHandler(result, response.response?.statusCode ?? 0)
            case .failure(let error):
                print("failure\n", error)
            }
        }
        
    }
    
    func getPhotoDetailAPI(imageID: String,
                           complitionHandler: @escaping (PhotoDetailResponseModel, Int) -> (Void))
    {
        guard let clientID = Bundle.main.client_id else {return}
        let url = "https://api.unsplash.com/photos/\(imageID)/statistics"
        let method: HTTPMethod = .get
        let parameters: [String: Any] = ["client_id": clientID]
        
        print("parameters : \(parameters)")
        
        AF.request(url, method: method, parameters: parameters).responseDecodable(of: PhotoDetailResponseModel.self) { response in
            switch response.result {
            case .success(let result):
                print("success")
                complitionHandler(result, response.response?.statusCode ?? 0)
            case .failure(let error):
                print("failure\n", error)
            }
        }
        
    }
    
    func getPhotoTopicAPI(topicID: String,
                          complitionHandler: @escaping ([PhotoTopicResponseModel], Int) -> (Void))
    {
        guard let clientID = Bundle.main.client_id else {return}
        let url = "https://api.unsplash.com/topics/\(topicID)/photos"
        let method: HTTPMethod = .get
        let parameters: [String: Any] = ["client_id": clientID]
        print("clientID :",clientID)
        
        
        AF.request(url, method: method, parameters: parameters).responseDecodable(of: [PhotoTopicResponseModel].self) { response in
            switch response.result {
            case .success(let result):
                print("success")
                complitionHandler(result, response.response?.statusCode ?? 0)
            case .failure(let error):
                print("failure\n", error)
            }
        }
        
    }
    
}
