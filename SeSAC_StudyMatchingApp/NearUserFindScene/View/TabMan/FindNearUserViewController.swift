//
//  FindNearUserViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/29.
//

import UIKit

import Tabman
import Pageboy
import RxCocoa
import RxSwift

final class FindNearUserViewController: TabmanViewController {
    
    private var viewControllers = [NearUserViewController(), ReceiveRequestViewController()]
    private let titleList = ["새싹 찾기", "받은 요청"]
    
    var disposeBag = DisposeBag()
    
    private let backBarButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrow.left")
        $0.tintColor = .black
    }
    private let cancelSearchButton = UIBarButtonItem().then {
        $0.title = "찾기중단"
        $0.tintColor = .black
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        bar.backgroundColor = .systemBackground
        bar.backgroundView.style = .blur(style: .regular)
        bar.buttons.customize { (button) in
            button.tintColor = .gray6
            button.selectedTintColor = .green
        }
        bar.indicator.weight = .light
        bar.indicator.tintColor = .green
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        navigationItem.title = "새싹 찾기"
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    func configureUI() {
        
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = cancelSearchButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        cancelSearchButton.target = self
        cancelSearchButton.rx.tap
            .bind { [weak self] in
                let vc = HomeViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen // 풀스크린으로 설정
                self?.present(nav, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
    }
    
}

extension FindNearUserViewController: PageboyViewControllerDataSource, TMBarDataSource  {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = titleList[index]
        return TMBarItem(title: title)
    }
    
}

