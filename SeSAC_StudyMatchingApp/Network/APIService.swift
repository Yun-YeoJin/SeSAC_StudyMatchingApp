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

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
}

enum UserEnum: Int {
    case success = 200 //회원가입 성공
    case userExist = 201 //이미 가입한 유저
    case invalidNickname = 202 //사용할 수 없는 닉네임
    case firebaseTokenInvalid = 401 //파이어베이스 토큰 에러
    case userUnexist = 406 //미가입 회원
    case serverError = 500 //서버 에러
    case clientError = 501 //클라이언트 에러
}

// MARK: - API 요청하기 (Login / MyPage)
class APIService {
   
    static let shared = APIService()
    
    var disposeBag = DisposeBag()
    
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
    
    
}

