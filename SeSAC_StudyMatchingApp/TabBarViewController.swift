//
//  TabBarViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

//MARK: Tabman을 이용해서 TabBar 구성시 RootView 변경을 못시켜줘서 변경!
final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setupTabBarAppearence()
        
    }
   
    
    private func setupTabBar(viewController: UIViewController, title: String, image: String) -> UINavigationController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: image)
     
        let navigationViewController = UINavigationController(rootViewController: viewController)
        return navigationViewController
        
    }
    
    private func configureTabBar() {
        
        let homeVC = setupTabBar(viewController: HomeViewController(), title: "홈", image: TabImage.home)
        
        let shopVC = setupTabBar(viewController: ShopViewController(), title: "새싹샵", image: TabImage.shop)
      
        let friendVC = setupTabBar(viewController: FriendsViewController(), title: "새싹친구", image: TabImage.chat)
        
        let profileVC = setupTabBar(viewController: SettingViewController(), title: "내정보", image: TabImage.profile)

        setViewControllers([homeVC, shopVC, friendVC, profileVC], animated: true)
        
    }
    
    private func setupTabBarAppearence() {
        
        let tabBarAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBarAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green, NSAttributedString.Key.font: UIFont.title6_R12]
        appearance.stackedLayoutAppearance = tabBarAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
   
        tabBar.backgroundColor = .white
        tabBar.tintColor = .green
        
    }
    
}



