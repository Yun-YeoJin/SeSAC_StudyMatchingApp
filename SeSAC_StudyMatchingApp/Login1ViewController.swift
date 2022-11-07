//
//  Login1ViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift

final class Login1ViewController: BaseViewController {
    
    let mainView = Login1View()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.getAuthButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.navigationController?.pushViewController(Login2ViewController(), animated: true)
            }.disposed(by: disposeBag)
        
    }
    
   
    
}

