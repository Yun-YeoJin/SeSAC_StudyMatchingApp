//
//  NickNameViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class NickNameViewModel: CommonViewModel {
    
    struct Input {
        let nickNameText: ControlProperty<String>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let nickNameValid: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nickNameValid = input.nickNameText
            .map { $0.count > 0 && $0.count < 11 }
            .share()
        
        return Output(nickNameValid: nickNameValid, nextTap: input.nextTap)
    }
    
}
