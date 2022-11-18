//
//  EndPoint.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/10.
//

import Foundation

enum Endpoint {
    case login, register
    case updateFCMToken
    case withdraw
    case userMyPage
    case requestSearchUser, cancelSearchUser
    case searchSeSAC
    case checkUserQueueState
}

extension Endpoint {
    
    var url: URL {
        switch self {
        case .login, .register:
            return .makeEndpoint("/v1/user")
        case .withdraw:
            return .makeEndpoint("/v1/user/withdraw")
        case .updateFCMToken:
            return .makeEndpoint("/v1/user/update_fcm_token")
        case .userMyPage:
            return .makeEndpoint(("/v1/user/mypage"))
        case .requestSearchUser, .cancelSearchUser:
            return .makeEndpoint("/v1/queue")
        case .searchSeSAC:
            return .makeEndpoint("/v1/queue/search")
        case .checkUserQueueState:
            return .makeEndpoint("/v1/queue/myQueueState")
        }
    }
    
}

extension URL {
    
    static let baseURL = "http://api.sesac.co.kr:1210"
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        
        URL(string: baseURL + endpoint)!
        
    }
    
}


