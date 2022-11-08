//
//  BirthViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class BirthViewController: BaseViewController {
    
    let mainView = BirthView()
    
    let viewModel = BirthViewModel()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
                
    }
    
    override func configureUI() {
        
        navigationItem.leftBarButtonItem = backBarButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
    private func bind() {
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.navigationController?.pushViewController(EmailViewController(), animated: true)
            }.disposed(by: disposeBag)
        
    }
    
}



