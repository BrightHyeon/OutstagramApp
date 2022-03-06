//
//  TabBarController.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/06.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedViewController = UINavigationController(rootViewController: FeedViewController())
        feedViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill") //이거안해도 알아서되긴함.
        )
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [feedViewController, profileViewController] //tag안달아도 순서대로 나옴.
        
        //tabBar border settings.
        tabBar.layer.borderWidth = 0.2
        tabBar.layer.borderColor = UIColor.label.cgColor
        
    }
    
}
