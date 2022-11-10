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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
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
            }.disposed(by: disposebag)
        
    }
    
    private func bind() {
        
        mainView.nickNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.nickNameObserver)
            .disposed(by: disposeBag)
        
        viewModel.nickNameObserver
            .map(viewModel.checkNickNameValid)
            .bind(to: viewModel.isValid)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: { data in
                if data {
                    self.mainView.nextButton.backgroundColor = .green
                } else {
                    self.mainView.nextButton.backgroundColor = .gray6
                }
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind { value in
                if self.viewModel.isValid.value {
                    self.navigationController?.pushViewController(BirthViewController(), animated: true)
                } else {
                    self.view.makeToast("닉네임은 1자 이상 10자 이내만 가능합니다.", position: .top)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}


