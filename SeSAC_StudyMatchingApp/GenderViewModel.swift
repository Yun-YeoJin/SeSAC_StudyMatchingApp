//
//  GenderViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class GenderViewModel {
    
    let genderButtonObserver = BehaviorRelay<Int>(value: -1)

    let isValid = BehaviorRelay<Bool>(value: false)
    
    var gender: CObservable<Int> = CObservable(0)
    
    func checkValidButton(genderValue: Int) -> Bool {
        
        gender.value = genderButtonObserver.value
        
        if genderValue == 0 || genderValue == 1 {
            return true
        }
        
        return false
    }
    
    func register(completion: @escaping (String, UserEnum) -> Void) {
        
        APIService.shared.register(
            phoneNum: UserDefaultsRepository.fetchPhoneNumber(),
            FCMtoken: UserDefaultsRepository.fetchFCMToken(),
            nickName: UserDefaultsRepository.fetchUserNickname(),
            birth: UserDefaultsRepository.fetchUserBirth(),
            email: UserDefaultsRepository.fetchUserEmail(),
            gender: UserDefaultsRepository.fetchUserGender(),
            completion: { data, code in
            
            switch code {
            case .success:
                UserDefaultsRepository.saveidForCredentialFirebase(credentialId: data?.uid ?? "")
                completion("", code)
            case .userExist:
                completion("이미 가입된 유저입니다.", code)
            case .firebaseTokenInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("OK", code)
                    default:
                        completion("토큰 에러", code)
                    }
                }
            default:
                completion("", code)
            }
        })
    }
    
    func getFCMToken(completion: @escaping (String, UserEnum) -> Void) {
        
        APIService.shared.updateFCMToken { status in
            switch status {
            case .serverError:
                completion("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", status)
            default:
                completion("", status)
            }
        }
    }
}
