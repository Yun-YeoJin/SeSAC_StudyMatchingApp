//
//  MyInfoViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import Foundation

import RxCocoa
import RxSwift
import Toast

class MyInfoViewModel {
    
    let title = BehaviorRelay<[String]>(value: ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"])
    
    let searchAble = BehaviorRelay<Int>(value: 0)
    let gender = BehaviorRelay<Int>(value: 0)
    let study = BehaviorRelay<String>(value: "")
    let searchAge = BehaviorRelay<[Int]>(value: [])
    
    func userInfo(completion: @escaping (String, UserEnum) -> Void) {
        
        APIService.shared.userMyPage(searchable: searchAble.value, ageMin: searchAge.value[0], ageMax: searchAge.value[1], gender: gender.value, study: study.value) { data, code in
            switch code {
                
            case .success:
                completion("성공", code)
            case .firebaseTokenInvalid:
                self.getFCMToken { message, code in
                    switch code {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .userUnexist:
                completion("가입되지 않은 유저", code)
            case .serverError:
                completion("서버 에러", code)
            case .clientError:
                completion("사용자 에러 발생", code)
                
            default: completion("", code)
                
            }
        }
    }
    
    func withdrawUser(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.withdraw(completion: { data, code in
            switch code {
            case .success:
                completion("", code)
                UserDefaults.standard.removeObject(forKey: "idToken")
                UserDefaults.standard.removeObject(forKey: "secondRun")
                UserDefaults.standard.removeObject(forKey: "FCMtoken")
                
            case .firebaseTokenInvalid:
                self.getFCMToken { message, code in
                    switch code {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .userUnexist:
                completion("가입되지 않은 유저", code)
            case .serverError:
                completion("서버 에러", code)
            case .clientError:
                completion("사용자 에러 발생", code)
                
            default: completion("", code)
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
