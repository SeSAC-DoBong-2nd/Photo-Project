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
            return UserDefaults.standard.string(forKey: "nickname") ?? "NO NAME"
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "nickname")
        }
    }
    
    var birthday: String {
        get {
            return UserDefaults.standard.string(forKey: "birthday") ?? "NO DATE"
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "birthday")
        }
    }
    
    var level: String {
        get {
            return UserDefaults.standard.string(forKey: "level") ?? "NO LEVEL"
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "level")
        }
    }
    
}
//bool, int는 기본 값이 있다.
