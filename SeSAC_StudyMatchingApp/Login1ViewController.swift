//
//  Login1ViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseAuth
import Toast

final class Login1ViewController: BaseViewController {
    
    let mainView = Login1View()
    
    let viewModel = Login1ViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkSecondRun()
        bind()
        
    }
    
    private func checkSecondRun() {
        
        if  UserDefaultsRepository.fetchSecondRun() == false {
            
            let vc = OnBoardingViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    private func bind() {

        mainView.phoneNumber.rx.text
            .orEmpty
            .map(viewModel.setHyphen)
            .bind(to: viewModel.phoneNumberObserver)
            .disposed(by: disposeBag)

        viewModel.phoneNumberObserver
            .map(viewModel.checkValidate)
            .bind(to: viewModel.isValid)
            .disposed(by: disposeBag)

        viewModel.isValid
            .subscribe(onNext: { data in
                if data {
                    self.mainView.getAuthButton.backgroundColor = .green
                } else {
                    self.mainView.getAuthButton.backgroundColor = .gray6
                }
            })
            .disposed(by: disposeBag)

        viewModel.phoneNumberObserver
            .subscribe(onNext: { value in
                self.mainView.phoneNumber.text = value
            })
            .disposed(by: disposeBag)

        mainView.getAuthButton.rx.tap
            .bind(onNext: { value in
                if self.viewModel.isValid.value {
                    self.view.makeToast("전화 번호 인증 시작", position: .top)
                    // firebase 통신
                    self.viewModel.verifyPhoneNumber { state in
                        switch state {
                        case .tooManyRequests:
                            self.view.makeToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.", position: .top)
                        case .success:
                            self.navigationController?.pushViewController(Login2ViewController(), animated: true)
                        case .unknownError:
                            self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요.", position: .top)
                        }
                    }
                } else {
                    self.view.makeToast("잘못된 전화번호 형식입니다.", position: .top)
                }
            })
            .disposed(by: disposeBag)
    }
    

}

