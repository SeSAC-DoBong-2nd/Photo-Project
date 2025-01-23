//
//  UserDefaultsManager.swift
//  PhotoProject
//
//  Created by 박신영 on 1/23/25.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    var isNotFirstLoading: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isNotFirstLoading")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "isNotFirstLoading")
        }
    }
    
    var nickname: String {
        get {
            return UserDefaults.standard.string(forKey: "nickname") ?? "Unknown"
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "nickname")
        }
    }
    
    var birthday: String {
        get {
            return UserDefaults.standard.string(forKey: "birthday") ?? "Unknown"
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "birthday")
        }
    }
    
}
