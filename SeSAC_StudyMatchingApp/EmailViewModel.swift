//
//  EmailViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class EmailViewModel {
    
    let emailObserver = BehaviorRelay<String>(value: "")
    
    let isValid = BehaviorRelay<Bool>(value: false)
    
    var userEmail: CObservable<String> = CObservable("")
    
    
    func checkValidEmail(_ email: String) -> Bool {
        
        userEmail.value = email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
}
