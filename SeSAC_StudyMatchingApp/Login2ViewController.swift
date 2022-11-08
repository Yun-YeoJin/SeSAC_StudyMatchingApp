//
//  Login2ViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift

final class Login2ViewController: BaseViewController {
    
    private let mainView = Login2View()
    
    private let viewModel = Login2ViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        
        
    }
    
    private func bind() {
        
        let input = Login2ViewModel.Input(phoneNumText: mainView.phoneNumber.rx.text.orEmpty, getAuthTap: mainView.getAuthButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.phoneNumValid
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.getAuthButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.phoneNumValid
            .map { $0 == true ? UIColor.green : UIColor.gray6 }
            .asDriver(onErrorJustReturn: .gray6)
            .drive(mainView.getAuthButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        input.getAuthTap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.navigationController?.pushViewController(NickNameViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        
    }
    
    
    override func configureUI() {
        
        navigationItem.leftBarButtonItem = backBarButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
}

