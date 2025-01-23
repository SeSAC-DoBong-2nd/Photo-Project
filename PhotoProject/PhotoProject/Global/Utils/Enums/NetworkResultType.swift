//
//  ErrorType.swift
//  PhotoProject
//
//  Created by 박신영 on 1/22/25.
//

import UIKit

enum NetworkResultType {
    case success
    case badRequest //400
    case unauthorized //401
    case forbidden //403
    case notFound //404
    case serverError //500, 503
    case anotherError
    
    var alert: UIAlertController {
        switch self {
        case .success:
            return UIAlertManager.showAlert(title: "Ok", message: "축하!")
        case .badRequest:
            return UIAlertManager.showAlert(title: "Bad Request", message: "필수 요청사항 중 누락된 것이 없나 점검해주세요.")
        case .unauthorized:
            return UIAlertManager.showAlert(title: "Unauthorized", message: "유효하지 않은 Token 입니다.")
        case .forbidden:
            return UIAlertManager.showAlert(title: "Forbidden", message: "요청을 수행할 수 있는 권한이 없습니다.")
        case .notFound:
            return UIAlertManager.showAlert(title: "Not Found", message: "리소스를 찾지 못하였습니다.")
        case .serverError:
            return UIAlertManager.showAlert(title: "Server Error", message: "서버 에러가 발생하였습니다.")
        case .anotherError:
            return UIAlertManager.showAlert(title: "Another Error", message: "에러가 발생하였습니다.")
        }
    }
}
