//
//  Login1ViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class Login1ViewModel: CommonViewModel {
  
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
            .map { $0.count == 13 && $0.contains("010-")}
            .share()
        
        return Output(phoneNumValid: phoneNumValid, getAuthTap: input.getAuthTap)
    }
    
}


