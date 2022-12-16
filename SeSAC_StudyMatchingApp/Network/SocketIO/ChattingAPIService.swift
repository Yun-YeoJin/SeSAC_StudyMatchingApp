//
//  ChattingAPIService.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/14.
//

import Foundation
import Alamofire

class ChattingAPIService {
    static let shared = ChattingAPIService()
    
    private init() { }
    
    func requestGETAPI(router: URLRequestConvertible ,completion: @escaping (Result<GetChatData, Error>) -> Void) {
        AF.request(router).responseDecodable(of: GetChatData.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else {return}
                guard let error = SeSACError(rawValue: statusCode) else {return}
                completion(.failure(error))
            }
        }
    }
    
    func requestPOSTAPI(router: URLRequestConvertible ,completion: @escaping (Result<Payload, Error>) -> Void) {
        AF.request(router).responseDecodable(of: Payload.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else {return}
                guard let error = SeSACError(rawValue: statusCode) else {return}
                completion(.failure(error))
            }
        }
    }
    
}
