//
//  BaseViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {}
    
    func setLayout() {}
    
    func setStyle() {
        view.backgroundColor = .white
    }
    
    func setChildrenViewLayout<T: BaseView>(view: T) {
        view.setLayout()
    }
    
    func viewTransition<T: UIViewController>(viewController: T, transitionStyle: ViewTransitionType) {
        switch transitionStyle {
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .present:
            return self.present(viewController, animated: true)
        case .presentWithNav:
            let nav = UINavigationController(rootViewController: viewController)
            return self.present(nav, animated: true)
        case .presentFullScreenWithNav:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            return self.present(nav, animated: true)
        }
    }
    
}
