//
//  APIService.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/10.
//

import Foundation

import Alamofire
import Firebase
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
    func requestSearchUser(long: Double, lat: Double, studylist: [String], completion: @escaping (Queue?, SearchQueueEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "lat": lat,
            "long": long,
            "studylist": studylist
        ]
        
        RxAlamofire.requestData(.post, Endpoint.requestSearchUser.url, parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
            .subscribe{ (header, data) in
                let apiState = SearchQueueEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteOnqueue(completion: @escaping (Queue?, SearchQueueEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        RxAlamofire.requestData(.delete, Endpoint.cancelSearchUser.url, headers: headers)
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
            "lat": lat,
            "long": long
        ]
        
        RxAlamofire.requestData(.post, Endpoint.searchSeSAC.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = SearchQueueEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func checkMyQueueState(completion: @escaping (Queue?, StudyAcceptEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        RxAlamofire.requestData(.get, Endpoint.checkUserQueueState.url, headers: headers)
            .subscribe{ (header, data) in
                let apiState = StudyAcceptEnum(rawValue: header.statusCode)!
                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
   
    
    func studyRequest(otheruid: String, completion: @escaping (Queue?, StudyAcceptEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "otheruid": otheruid
        ]
        
        RxAlamofire.requestData(.post, Endpoint.studyRequest.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = StudyAcceptEnum(rawValue: header.statusCode)!
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

