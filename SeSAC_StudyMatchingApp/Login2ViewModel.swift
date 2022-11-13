//
//  Login2ViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift
import FirebaseAuth

enum VerifyNumberAuthStatus: Int, Error {
    case validityExpired
    case wrongVerificationNumber
    case tokenFail
    case unknownError
    case success
}

class Login2ViewModel {
    
    let verifyNumberObserver = BehaviorSubject<String>(value: "")
    var verificationNumber = ""
    
    let validNum = BehaviorRelay<Bool>(value: false)
    
    func checkValidateNum(text: String) -> Bool {
        verificationNumber = text
        
        if text.count == 6 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - API 요청하기
    func checkValidId(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.getLogin { data, Errorcode in
            
            switch Errorcode {
            case .success:
                //UserDefaults.standard.set(data?.uid, forKey: "userID")
                UserDefaultsRepository.saveidForCredentialFirebase(credentialId: data?.uid ?? "")
                print("userID : ", data?.uid ?? "NO ID")
                completion("", Errorcode)
            case .userExist:
                completion("이미 존재하는 사용자입니다. \(Errorcode)", Errorcode)
            case .serverError:
                completion("서버 에러입니다. \(Errorcode)", Errorcode)
            default:
                completion("", Errorcode)
            }
            
        }
    }
    
    // MARK: - FireBase 요청
    func checkValidate(completion: @escaping (String, VerifyNumberAuthStatus) -> Void) {
        FirebaseRepository.shared.checkValidate(verificationNumber: verificationNumber) { status in
            
            switch status {
            case .success:
                completion("", status)
            case .validityExpired, .wrongVerificationNumber:
                completion("전화번호 인증실패 \(status)", status)
            case .tokenFail, .unknownError:
                completion("에러가 발생했습니다. 잠시 후 다시 시도해주세요. \(status)", status)
            }
        }
    }
    
    
}
