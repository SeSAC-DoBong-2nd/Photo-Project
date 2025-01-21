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
    
    func getPhotoSearch(apiHandler: UnsplashTargetType,
                        complitionHandler: @escaping (PhotoSearchResponseModel, Int) -> (Void))
    {
        print("parameter : ",apiHandler.parameter)
        AF.request(apiHandler.endPoint, method: apiHandler.method, parameters: apiHandler.parameter, headers: apiHandler.header)
            .responseDecodable(of: PhotoSearchResponseModel.self) { response in
                debugPrint(response)
            switch response.result {
            case .success(let result):
                print("success")
                complitionHandler(result, response.response?.statusCode ?? 0)
            case .failure(let error):
                print("failure\n", error)
            }
        }
        
    }
    
    func getPhotoDetail(apiHandler: UnsplashTargetType,
                        complitionHandler: @escaping (PhotoDetailResponseModel, Int) -> (Void))
    {
        AF.request(apiHandler.endPoint, method: apiHandler.method, parameters: apiHandler.parameter, headers: apiHandler.header).responseDecodable(of: PhotoDetailResponseModel.self) { response in
            switch response.result {
            case .success(let result):
                print("success")
                complitionHandler(result, response.response?.statusCode ?? 0)
            case .failure(let error):
                print("failure\n", error)
            }
        }
        
    }
    
    func getPhotoTopic(apiHandler: UnsplashTargetType,
                       complitionHandler: @escaping ([PhotoTopicResponseModel], Int) -> (Void))
    {
        
        AF.request(apiHandler.endPoint, method: apiHandler.method, headers: apiHandler.header).responseDecodable(of: [PhotoTopicResponseModel].self) { response in
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

