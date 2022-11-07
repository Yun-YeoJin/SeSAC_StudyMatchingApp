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

final class Login1ViewController: BaseViewController {
    
    private let mainView = Login1View()
    
    private let viewModel = Login1ViewModel()
    
    private var disposeBag = DisposeBag()
    
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
        
        bind()
    }
    
    private func bind() {
        
        let input = Login1ViewModel.Input(phoneNumText: mainView.phoneNumber.rx.text.orEmpty, getAuthTap: mainView.getAuthButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        input.phoneNumText
            .subscribe(onNext: { value in
                self.mainView.phoneNumber.text = self.phoneNumberformat(with: "XXX-XXXX-XXXX", phone: value)
            })
            .disposed(by: disposeBag)
        
        output.phoneNumValid
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.getAuthButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.phoneNumValid
            .map{ $0 == true ? UIColor.green : UIColor.gray6 }
            .asDriver(onErrorJustReturn: .gray6)
            .drive(mainView.getAuthButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.getAuthTap
            .withUnretained(self)
            .subscribe { value in
                self.verifyPhoneNumber("+82 10-6390-7469")
            }
            .disposed(by: disposeBag)
        
    }
    
    private func verifyPhoneNumber(_ phoneNumber: String) {
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    return
                }
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
        
        Auth.auth().languageCode = "kr"
    }
    
    
    private func checkNumberValid(_ phoneNumber: String) -> Bool {
        return phoneNumber.count == 13 && phoneNumber.contains("010-")
    }
    
    func phoneNumberformat(with mask: String, phone: String) -> String {
        
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
               
                result.append(numbers[index])
                index = numbers.index(after: index)

            } else {
                result.append(ch)
            }
        }
        return result
        
    }
   
    
}

