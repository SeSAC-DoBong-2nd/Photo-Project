//
//  Bundle+Extension.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import Foundation

extension Bundle {
    
    var client_id: String? {
        return infoDictionary?["CLIENT_ID"] as? String
    }
    
}
