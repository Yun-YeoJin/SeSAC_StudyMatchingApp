//
//  HomeViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    let lat = BehaviorRelay<Double>(value: 37.517819364682694)
    let long = BehaviorRelay<Double>(value: 126.88647317074734)
    let region = BehaviorRelay<Int>(value: 0)
    
    let data = BehaviorRelay<Queue>(value: Queue(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
    
    var reputation = BehaviorRelay<[[Int]]>(value: [])
    
    lazy var studyListData: [String] = []
    lazy var studyListUser: [String] = []
    
    var fromRecommend: CObservable<[String]> = CObservable([])
    
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
