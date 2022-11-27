//
//  APIService.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/10.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

class APIService {
   
    static let shared = APIService()
    
    var disposeBag = DisposeBag()
    
    // MARK: - API 요청하기 (Login / MyPage)
    func getLogin(completion: @escaping (User?, UserEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        RxAlamofire.requestData(.get, Endpoint.login.url, parameters: nil, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                let decodedData = try? JSONDecoder().decode(User.self, from: data)
    
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func register(phoneNum: String, FCMtoken: String, nickName: String, birth: String, email: String, gender: Int, completion: @escaping (User?, UserEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "phoneNumber": phoneNum,
            "FCMtoken": FCMtoken,
            "nick": nickName,
            "birth": birth,
            "email": email,
            "gender": gender
        ]
        
        dump(parameters)
        
        RxAlamofire.requestData(.post, Endpoint.register.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(User.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func withdraw(completion: @escaping (User?, UserEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        RxAlamofire.requestData(.post, Endpoint.withdraw.url, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(User.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func updateFCMToken(completion: @escaping (UserEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "FCMtoken": UserDefaultsRepository.fetchFCMToken()
        ]
        
        RxAlamofire.requestData(.put, Endpoint.updateFCMToken.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                completion(apiState)
            }
            .disposed(by: disposeBag)
        
    }
    
    func userMyPage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String, completion: @escaping (User?, UserEnum) -> Void) {
       
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "searchable": searchable,
            "ageMin": ageMin,
            "ageMax": ageMax,
            "gender": gender,
            "study": study
        ]
        
        dump(parameters)
        
        RxAlamofire.requestData(.put, Endpoint.userMyPage.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(User.self, from: data)

                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: Queue
    func requestSearchUser(long: Double, lat: Double, studylist: String, completion: @escaping (Queue?, SearchQueueEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "long": long,
            "lat": lat,
            "studylist": studylist
        ]
        
        RxAlamofire.requestData(.post, Endpoint.requestSearchUser.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = SearchQueueEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func searchNearSeSAC(long: Double, lat: Double, completion: @escaping (Queue?, SearchQueueEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "long": long,
            "lat": lat,
        ]
        
        RxAlamofire.requestData(.post, Endpoint.searchSeSAC.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = SearchQueueEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func checkMyQueueState(completion: @escaping (Queue?, QueueStateEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        RxAlamofire.requestData(.get, Endpoint.searchSeSAC.url, headers: headers)
            .subscribe{ (header, data) in
                let apiState = QueueStateEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func studyRequest(otheruid: String, completion: @escaping (Queue?, StudyRequestEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "otheruid": otheruid
        ]
        
        RxAlamofire.requestData(.post, Endpoint.studyRequest.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = StudyRequestEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func studyAccept(otheruid: String, completion: @escaping (Queue?, StudyAcceptEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "otheruid": otheruid
        ]
        
        RxAlamofire.requestData(.post, Endpoint.studyAccept.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = StudyAcceptEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
}

