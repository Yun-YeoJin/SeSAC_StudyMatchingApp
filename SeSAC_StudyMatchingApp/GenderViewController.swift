//
//  GenderViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class GenderViewController: BaseViewController {
    
    let mainView = GenderView()
    
    let viewModel = GenderViewModel()
    
    let disposeBag = DisposeBag()
    
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
        
        mainView.maleButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.genderButtonObserver.accept(1) //왜 자꾸 0이 저장되는거지
                vc.mainView.maleButton.backgroundColor = .whiteGreen
                vc.mainView.femaleButton.backgroundColor = .clear
            }.disposed(by: disposebag)
        
        mainView.femaleButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.genderButtonObserver.accept(0)
                vc.mainView.maleButton.backgroundColor = .clear
                vc.mainView.femaleButton.backgroundColor = .whiteGreen
            }.disposed(by: disposeBag)
        
        viewModel.genderButtonObserver
            .map(viewModel.checkValidButton)
            .bind(to: viewModel.isValid)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .withUnretained(self)
            .subscribe { vc, data in
                if data {
                    vc.mainView.nextButton.buttonState = .fill
                } else {
                    vc.mainView.nextButton.buttonState = .disable
                }
            }.disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind {
                if self.viewModel.isValid.value {
                    UserDefaultsRepository.saveGender(gender: self.viewModel.genderButtonObserver.value)
                    self.register()
                } else {
                    self.view.makeToast("회원가입이 불가해요!")
                }
            }
            .disposed(by: disposeBag)
        
    }
}

// MARK: - API Methods
extension GenderViewController {
    func register() {
        self.viewModel.register { message, code in
            switch code {
            case .success:
                //self.navigationController?.pushViewController(TabBarViewController(), animated: true)
                self.transition(TabBarViewController(), transitionStyle: .presentFullNavigation)
                print("=====================================================")
                print("FCM token: \(UserDefaultsRepository.fetchFCMToken())")
                print("id token: \(UserDefaultsRepository.fetchUserIDToken())")
                print("PhoneNumber: \(UserDefaultsRepository.fetchPhoneNumber())")
                print("NickName: \(UserDefaultsRepository.fetchUserNickname())")
                print("Birth: \(UserDefaultsRepository.fetchUserBirth())")
                print("Email: \(UserDefaultsRepository.fetchUserEmail())")
                print("Gender: \(UserDefaultsRepository.fetchUserGender())")
            case .invalidNickname:
                self.navigationController?.popToViewController(NickNameViewController(), animated: true)
            case .firebaseTokenInvalid:
                self.register()
            default:
                self.view.makeToast("이미 존재하는 회원입니다.")
                print("=====================================================")
                print("FCM token: \(UserDefaultsRepository.fetchFCMToken())")
                print("id token: \(UserDefaultsRepository.fetchUserIDToken())")
                print("PhoneNumber: \(UserDefaultsRepository.fetchPhoneNumber())")
                print("NickName: \(UserDefaultsRepository.fetchUserNickname())")
                print("Birth: \(UserDefaultsRepository.fetchUserBirth())")
                print("Email: \(UserDefaultsRepository.fetchUserEmail())")
                print("Gender: \(UserDefaultsRepository.fetchUserGender())")
            }
        }
    }
}
