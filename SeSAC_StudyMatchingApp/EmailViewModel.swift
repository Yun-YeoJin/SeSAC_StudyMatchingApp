//
//  EmailViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class EmailViewModel: CommonViewModel {
    
    struct Input {
        let emailText: ControlProperty<String>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailValid: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValid = input.emailText
            .map(isValidEmail)
            .share()
        
        return Output(emailValid: emailValid, nextTap: input.nextTap)
        
        func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
    }
    
}
