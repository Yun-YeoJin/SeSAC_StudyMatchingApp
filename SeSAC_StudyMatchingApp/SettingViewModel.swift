//
//  SettingViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/13.
//

import Foundation

import RxCocoa

final class SettingViewModel {
    
    let nickName = BehaviorRelay<String>(value: "윤여진")
    
    func getUserInfo(completion: @escaping (String, UserEnum) -> Void) {
        
        APIService.shared.getLogin(completion: { [self] data, code in
            switch code {
            case .success:
                completion("", code)
            case .firebaseTokenInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
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

