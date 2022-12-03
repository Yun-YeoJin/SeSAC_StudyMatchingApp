//
//  SplashViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/14.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.splashImageView.alpha = 0 // 이미지의 투명도를 0으로 변경
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
                      // 동작할 애니메이션에 대한 코드
                      self.splashImageView.alpha = 1
                      }, completion: { finished in
                          // 애니메이션이 종료되었을 때의 코드
//                          let vc = TabBarViewController()
//                          let nav = UINavigationController(rootViewController: vc)
//                          nav.modalPresentationStyle = .fullScreen // 풀스크린으로 설정
//                          self.present(nav, animated: true, completion: nil)
                          
                          if UserDefaultsRepository.fetchUserIDToken() == "" {
                              let vc = Login1ViewController()
                              let nav = UINavigationController(rootViewController: vc)
                              nav.modalPresentationStyle = .fullScreen // 풀스크린으로 설정
                              self.present(nav, animated: true, completion: nil)
                              // 뷰가 등장하는 애니메이션 효과인 animated는 false로 설정
                          } else if UserDefaultsRepository.fetchUserIDToken() != "" {
                              let vc = TabBarViewController()
                              let nav = UINavigationController(rootViewController: vc)
                              nav.modalPresentationStyle = .fullScreen // 풀스크린으로 설정
                              self.present(nav, animated: true, completion: nil)
                              // 뷰가 등장하는 애니메이션 효과인 animated는 false로 설정
                          }
                      })
        
    }
    

}
