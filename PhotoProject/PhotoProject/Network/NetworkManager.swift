//
//  NetworkManager.swift
//  PhotoProject
//
//  Created by 박신영 on 1/19/25.
//

import Foundation

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func returnErrorType(_ statusCode: Int) -> NetworkResultType {
        switch statusCode {
        case (200..<299):
            return .success
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case (500...):
            return .serverError
        default:
            return .anotherError
        }
    }
    
    //Generic 활용: (Type Annotation).ver
    func getUnsplashAPIWithTypeAnnotation<T: Decodable>(apiHandler: UnsplashTargetType,
                                                       complitionHandler: @escaping (T, NetworkResultType) -> (Void))
    {
        print("parameter : ",apiHandler.parameter)
        AF.request(apiHandler.endPoint, method: apiHandler.method, parameters: apiHandler.parameter, headers: apiHandler.header)
            .responseDecodable(of: T.self) { response in
                debugPrint(response)
            switch response.result {
            case .success(let result):
                print("success")
                let networkResultType = self.returnErrorType(response.response?.statusCode ?? 0)
                complitionHandler(result, networkResultType)
            case .failure(let error):
                print("failure\n", error)
            }
        }
    }
    
    //Generic 활용: (Meta Type).ver
    func getUnsplashAPIWithMetaType<T: Decodable>(apiHandler: UnsplashTargetType,
                                                  responseModel: T.Type,
                                                  complitionHandler: @escaping (T, NetworkResultType) -> (Void))
    {
        print("parameter : ",apiHandler.parameter)
        AF.request(apiHandler.endPoint, method: apiHandler.method, parameters: apiHandler.parameter, headers: apiHandler.header)
            .responseDecodable(of: T.self) { response in
                debugPrint(response)
            switch response.result {
            case .success(let result):
                print("success")
                let networkResultType = self.returnErrorType(response.response?.statusCode ?? 0)
                complitionHandler(result, networkResultType)
            case .failure(let error):
                print("failure\n", error)
            }
        }
    }
    
}



//Generic 활용: (Type Annotation) 호출.ver
//        NetworkManager.shared.getUnsplashAPIWithTypeAnnotation(apiHandler: .getPhotoDetail(imageID: imageID))
//        { (result: PhotoDetailResponseModel, networkResultType)  in
//            switch networkResultType {
//            case .success:
//                print("result!!! : \(result)")
//            case .badRequest, .unauthorized, .forbidden, .notFound, .serverError, .anotherError:
//                let alert = networkResultType.alert
//                self.present(alert, animated: true)
//            }
//        }

//Generic 활용: (Meta Type) 호출.ver
//        NetworkManager.shared.getUnsplashAPIWithMetaType(apiHandler: .getPhotoDetail(imageID: imageID), responseModel: PhotoDetailResponseModel.self) { result, networkResultType in
//            switch networkResultType {
//            case .success:
//                print("networkResultType : Success")
//            case .badRequest, .unauthorized, .forbidden, .notFound, .serverError, .anotherError:
//                let alert = networkResultType.alert
//                self.present(alert, animated: true)
//            }
//        }
