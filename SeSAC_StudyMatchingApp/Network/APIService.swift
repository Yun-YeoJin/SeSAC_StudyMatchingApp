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
        
        RxAlamofire.requestData(.put, Endpoint.userMyPage.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(User.self, from: data)

                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
}

class SeSACAPIService {
    
    static let shared = SeSACAPIService()
    
    private init() { }
    
    func requestSeSACAPI<T: Codable>(type: T.Type = T.self, router: URLRequestConvertible ,completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
                //dump(result)
            case .failure(_):
                guard let statusCode = response.response?.statusCode else {return}
                guard let error = SeSACError(rawValue: statusCode) else {return}
                completion(.failure(error))
            }
        }
    }
    
    func requestStatusSeSACAPI(router: URLRequestConvertible ,completion: @escaping (Int) -> Void) {
        AF.request(router).responseString { response in
            //dump(response)
            guard let statusCode = response.response?.statusCode else {return}
            
            completion(statusCode)
            
        }
    }
}

