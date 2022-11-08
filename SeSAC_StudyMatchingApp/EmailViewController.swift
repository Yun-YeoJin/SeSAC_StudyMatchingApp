//
//  EmailViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class EmailViewController: BaseViewController {
    
    private let mainView = EmailView()
    
    private let viewModel = EmailViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        
        let input = EmailViewModel.Input(emailText: mainView.emailTextField.rx.text.orEmpty, nextTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.emailValid
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValid
            .map { $0 == true ? UIColor.green : UIColor.gray6 }
            .asDriver(onErrorJustReturn: .gray6)
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        input.nextTap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.navigationController?.pushViewController(GenderViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        
        
        
    }
    
}
