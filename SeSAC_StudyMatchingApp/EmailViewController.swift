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
    
    let mainView = EmailView()
    
    let viewModel = EmailViewModel()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
       
        mainView.emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        viewModel.emailObserver
            .map(viewModel.checkValidEmail)
            .bind(to: viewModel.isValid)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe { data in
                if data {
                    self.mainView.nextButton.buttonState = .fill
                } else {
                    self.mainView.nextButton.buttonState = .disable
                }
            }
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind { value in
                if self.viewModel.isValid.value {
                    self.navigationController?.pushViewController(GenderViewController(), animated: true)
                    UserDefaultsRepository.saveEmail(email: self.mainView.emailTextField.text!)
                    print(UserDefaults.standard.string(forKey: "email"))
                } else {
                    self.view.makeToast("이메일 형식이 올바르지 않습니다.", position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        
        navigationItem.leftBarButtonItem = backBarButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposebag)
        
    }
    
}
