//
//  NickNameViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class NickNameViewController: BaseViewController {
    
    let mainView = NickNameView()
    
    let viewModel = NickNameViewModel()
    
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
        
        let input = NickNameViewModel.Input(nickNameText: mainView.nickNameTextField.rx.text.orEmpty, nextTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.nickNameValid
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nickNameValid
            .map{ $0 == true ? UIColor.green : UIColor.gray6 }
            .asDriver(onErrorJustReturn: .gray6)
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        input.nextTap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.navigationController?.pushViewController(BirthViewController(), animated: true)
            }.disposed(by: disposeBag)

    }
    
}


