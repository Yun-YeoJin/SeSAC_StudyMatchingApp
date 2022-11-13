//
//  Login1ViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift
import Toast

enum PhoneNumberAuthStatus: Error {
    case tooManyRequests
    case success
    case unknownError
}

class Login1ViewModel {
    
    let phoneNumberObserver = BehaviorSubject<String>(value: "")
    var phoneNum = ""
    
    let isValid = BehaviorRelay<Bool>(value: false)
    
    func verifyPhoneNumber(completion: @escaping (PhoneNumberAuthStatus) -> Void) {
        
        let number = "+82\(phoneNum)"
        var newNumber = number.components(separatedBy: ["-"]).joined()
        newNumber.remove(at: newNumber.index(newNumber.startIndex, offsetBy: 3))
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(newNumber, uiDelegate: nil) { verificationID, error in
                
                if let error = error {
                    let state = AuthErrorCode.Code(rawValue: error._code)
                    switch state {
                    case .tooManyRequests:
                        completion(.tooManyRequests)
                    default:
                        completion(.unknownError)
                    }
                    return
                }
                
                UserDefaultsRepository.saveAuthVerificationID(authVerificationID: verificationID!)
                UserDefaultsRepository.savePhoneNumber(phoneNumber: newNumber)
                
                completion(.success)
            }
    }

    
    // MARK: - Methods
    func checkValidate(text: String) -> Bool {
        
        let validText = text.replacingOccurrences(of: "-", with: "")
        
        phoneNum = validText
        
        if validText.count >= 10 {
            let firstString = validText[validText.startIndex]
            let secondString = validText[validText.index(validText.startIndex, offsetBy: 1)]
            
            if firstString != "0" && secondString != "1" { //010 or 011 시작
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func setHyphen(_ textInput: String) -> String {
        
        var text = textInput.replacingOccurrences(of: "-", with: "")
        
        switch text.count {
            
        case 0 ... 3:
            text = text.replacingOccurrences(of: "-", with: "")
            
        case 4 ... 6:
            text.insert("-", at: text.index(text.startIndex, offsetBy: 3))
            
        case 7 ... 10:
            let index = text.index(text.startIndex, offsetBy: 4)
            text.insert("-", at: text.index(text.startIndex, offsetBy: 3))
            text.insert("-", at: text.index(index, offsetBy: 3))
            
        default:
            let index = text.index(text.startIndex, offsetBy: 4)
            text.insert("-", at: text.index(text.startIndex, offsetBy: 3))
            text.insert("-", at: text.index(index, offsetBy: 4))
            
        }
        
        return text
        
    }
}
    


