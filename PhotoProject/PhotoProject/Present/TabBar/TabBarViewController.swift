//
//  TabBarViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        
        setTabBarControllerStyle()
        setTabBarAppearence ()
    }
    
    func setTabBarControllerStyle() {
        let topicVC = UINavigationController(rootViewController: PhotoTopicViewController())
        topicVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis")
        )
        
        let secondVC = UINavigationController(rootViewController: PhotoSearchViewController())
        secondVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "play.laptopcomputer"),
            selectedImage: UIImage(systemName: "play.laptopcomputer")
        )
        
        let searchVC = UINavigationController(rootViewController: PhotoSearchViewController())
        searchVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let heartVC = UINavigationController(rootViewController: PhotoTopicViewController())
        heartVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart")
        )
        
        setViewControllers([topicVC, secondVC, searchVC, heartVC], animated: true)
        
        self.tabBar.layer.borderWidth = 0.6
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        
        self.selectedIndex = 0
    }
    
    func setTabBarAppearence () {
        let appearence = UITabBarAppearance ()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = .white
        tabBar.standardAppearance = appearence
        tabBar.scrollEdgeAppearance = appearence
        tabBar.tintColor = .black
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print (item)
    }
}
