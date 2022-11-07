//
//  TabBarViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import Tabman
import Pageboy

final class TabBarViewController: TabmanViewController {
    
    private var vc = [MainViewController(), ShopViewController(), FriendsViewController(), ProfileViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        let bar = TMBar.TabBar()
        
        bar.backgroundColor = .systemBackground
        bar.backgroundView.style = .blur(style: .regular)
        bar.buttons.customize { (button) in
            button.tintColor = .gray6
            button.selectedTintColor = .green
        }
        bar.layout.transitionStyle = .snap // Customize
        
        // Add to view
        addBar(bar, dataSource: self, at: .bottom)
    }
}

extension TabBarViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vc.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vc[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        switch index {
        case 0: return TMBarItem(title: "홈", image: UIImage(named: "HomeGray")!, selectedImage: UIImage(named: "Home")!)
        case 1: return TMBarItem(title: "새싹샵", image: UIImage(named: "ShopGray")!, selectedImage: UIImage(named: "Shop")!)
        case 2: return TMBarItem(title: "새싹친구", image: UIImage(named: "FriendsGray")!, selectedImage: UIImage(named: "Friends")!)
        case 3: return TMBarItem(title: "내정보", image: UIImage(named: "ProfileGray")!, selectedImage: UIImage(named: "Profile")!)
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
      
    }
    
}

