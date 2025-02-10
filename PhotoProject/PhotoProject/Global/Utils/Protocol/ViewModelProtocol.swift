//
//  ViewModelProtocol.swift
//  PhotoProject
//
//  Created by 박신영 on 2/10/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
