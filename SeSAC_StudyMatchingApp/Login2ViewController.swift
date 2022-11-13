//
//  Login2ViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseAuth
import Toast

final class Login2ViewController: BaseViewController {
    
    let mainView = Login2View()
    
    let viewModel = Login2ViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.makeToast("인증번호를 보냈습니다.",position: .center)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        timerSetting()
        bind()
        
    }
    
    private func timerSetting() {
        
        let countdown = 60
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { countdown - $0 }
            .take(until: { $0 == -1 })
            .subscribe(onNext: { value in
                self.mainView.timeLabel.text = "\(value.description)초"
            }, onCompleted: {
                print("completed")
                self.view.makeToast("전화번호 인증 실패")
            }).disposed(by: disposeBag)
        
    }
    
    private func bind() {
        
        mainView.phoneNumber.rx.text
            .orEmpty
            .bind(to: viewModel.verifyNumberObserver)
            .disposed(by: disposeBag)
        
        viewModel.verifyNumberObserver
            .map(viewModel.checkValidateNum)
            .bind(to: viewModel.validNum)
            .disposed(by: disposeBag)
        
        viewModel.validNum
            .subscribe (onNext: { [self] data in
                if data {
                    mainView.getAuthButton.backgroundColor = .green
                } else {
                    mainView.getAuthButton.backgroundColor = .gray6
                }
            })
            .disposed(by: disposeBag)
        
        mainView.getAuthButton.rx.tap
            .bind(onNext: { [self] value in
                if viewModel.validNum.value == true {
                    checkValidateFirebaseAuthAndGetIdtoken()
                } else {
                    view.makeToast("잘못된 인증번호 입니다.", position: .top)
                }
            }).disposed(by: disposeBag)

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

// MARK: - API Request
extension Login2ViewController {
    
    func checkValidId() {
        
        self.viewModel.checkValidId { message, code in
            switch code {
            case .success:
                // 홈화면으로 이동
                self.navigationController?.pushViewController(NickNameViewController(), animated: true)
            case .firebaseTokenInvalid:
                self.refreshIDToken()
            case .userUnexist:
                // 회원가입 화면으로 이동
                self.navigationController?.pushViewController(NickNameViewController(), animated: true)
            default:
                self.view.makeToast(message, position: .top)
            }
        }
        
    }
    
    // id token 재발급
    func refreshIDToken() {
        FirebaseRepository.shared.getIdToken { status in
            switch status {
            case .unknownError:
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", position: .top)
                UserDefaults.standard.removeObject(forKey: "idToken")
            case .success:
                print("success : ", status)
                // 재요청
                self.checkValidateFirebaseAuthAndGetIdtoken()
            default:
                UserDefaults.standard.removeObject(forKey: "idToken")
                print(status)
            }
        }
    }
    
    func checkValidateFirebaseAuthAndGetIdtoken() {
        self.viewModel.checkValidate { message, status in
            switch status {
            case .success:
                // 뷰이동
                self.checkValidId()
            default:
                self.view.makeToast(message, position: .top)
                print(message)
            }
        }
    }
}


