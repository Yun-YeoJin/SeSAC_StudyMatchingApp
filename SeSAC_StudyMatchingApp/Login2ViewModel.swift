//
//  Login2ViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class Login2ViewModel: CommonViewModel {
    
    struct Input {
        let phoneNumText: ControlProperty<String>
        let getAuthTap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumValid: Observable<Bool>
        let getAuthTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let phoneNumValid = input.phoneNumText
            .map { $0.count == 6 }
            .share()
        
        return Output(phoneNumValid: phoneNumValid, getAuthTap: input.getAuthTap)
    }
    
}
