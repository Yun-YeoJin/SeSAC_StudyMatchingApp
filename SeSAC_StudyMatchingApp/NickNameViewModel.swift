//
//  NickNameViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class NickNameViewModel {
    
    let nickNameObserver = BehaviorRelay<String>(value: "")
    
    let isValid = BehaviorRelay<Bool>(value: false)
    
    var nickName: CObservable<String> = CObservable("")
    
    func checkNickNameValid(_ text: String) -> Bool {
        
        nickName.value = text
        
        if text.count > 10 || text.count < 1 {
            return false
        } else {
            return true
        }
    }
}
