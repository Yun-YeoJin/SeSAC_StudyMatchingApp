//
//  KeyWordViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import Foundation
import RxCocoa
import RxSwift

final class KeyWordViewModel {
    
    let lat = BehaviorRelay<Double>(value: 37.517819364682694)
    let long = BehaviorRelay<Double>(value: 126.88647317074734)
    let region = BehaviorRelay<Int>(value: 0)
    
    let data = BehaviorRelay<Queue>(value: Queue(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
    
    let title = BehaviorRelay<[String]>(value: ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"])
    
    var reputation = BehaviorRelay<[[Int]]>(value: [])
    var fromRecommend: CObservable<[String]> = CObservable([])
    
    lazy var studyListData: [String] = []
    lazy var studyListUser: [String] = []
    
    func caculateRegion() {
        
        let latTemp = String(lat.value + 90).components(separatedBy: ["."]).joined()
        let longTemp = String(long.value + 180).components(separatedBy: ["."]).joined()
        
        let latEndIdx: String.Index = latTemp.index(latTemp.startIndex, offsetBy: 4)
        let longEndIdx: String.Index = longTemp.index(longTemp.startIndex, offsetBy: 4)
        
        let latResult = String(latTemp[...latEndIdx])
        let longResult = String(longTemp[...longEndIdx])
    
        region.accept(Int([latResult, longResult].joined())!)
        
    }
    
    func nearFriendsData(data: [FromQueueDB]) -> [String] {
        var arr: [String] = []
        
        data.forEach {
            $0.studylist.forEach {
                arr.append($0.matchString(_string: $0))
            }
        }
        
        let removedDuplicate: Set = Set(arr)
        arr = Array(removedDuplicate)
        
        return arr
    }
    
    func getStudyData(_ data: String) -> StudyList {
        var arr = data.components(separatedBy: " ")
        arr = arr.filter { $0 != "" }
        
        if studyListUser.count > 8 {
            return .full
        }
        
        var tempArr: [String] = []
        
        tempArr += arr
        tempArr += studyListUser
        
        if tempArr.isEmpty {
            return .empty
        }
        
        let removedDuplicate: Set = Set(tempArr)
        tempArr = Array(removedDuplicate)
        
        print(tempArr)
        
        if tempArr.count > 8 {
            return .full
        }
        
        studyListUser = tempArr
        
        return .success
    }
    
    func searchQueue(completion: @escaping (String, SearchQueueEnum) -> Void) {
        APIService.shared.requestSearchUser(long: long.value, lat: lat.value, studylist: studyListUser, completion: { data, code in
            switch code {
            case .bannedUser:
                completion("신고가 누적되어 이용하실 수 없습니다.", code)
            case .studyCancelPenalty1:
                completion("약속 취소 패널티로, 1분동안 이용하실 수 없습니다", code)
            case .firebaseTokenInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .studyCancelPenalty2:
                completion("약속 취소 패널티로, 2분동안 이용하실 수 없습니다", code)
            case .studyCancelPenalty3:
                completion("연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다", code)
            default:
                completion("", code)
            }
        })
    }
    
    func searchNearSeSAC(completion: @escaping (String, SearchQueueEnum) -> Void) {
        APIService.shared.searchNearSeSAC(long: long.value, lat: lat.value, completion: { [self] dataValue, code in
            switch code {
            case .success:
                guard let queueData = dataValue else { return }
                data.accept(queueData)
                
                print("data : ", data.value)
                
                var arr: [[Int]] = []
                queueData.fromQueueDB.forEach {
                    arr.append($0.reputation)
                }
                reputation.accept(arr)
                
                studyListData.removeAll()
                studyListData += nearFriendsData(data: queueData.fromQueueDB)
                studyListData += nearFriendsData(data: queueData.fromQueueDBRequested)
                
                fromRecommend.value = queueData.fromRecommend
            
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
    
    func deleteQueue(completion: @escaping (String, SearchQueueEnum) -> Void) {
        APIService.shared.deleteOnqueue { [self] data, code in
            switch code {
            case .userUnexist:
                print("이미 매칭된 상태")
            case .firebaseTokenInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .serverError:
                print("server error")
            default:
                completion("", code)
            }
        }
    }
    
    func getFCMToken(completion: @escaping (String, UserEnum) -> Void) {
        FirebaseRepository.shared.updateFCMToken { status in
            switch status {
            case .serverError:
                completion("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", status)
            default:
                completion("", status)
            }
        }
    }
}
