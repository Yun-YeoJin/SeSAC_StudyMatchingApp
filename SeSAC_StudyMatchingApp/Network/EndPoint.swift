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
        }
    }
    
}

extension URL {
    
    static let baseURL = "http://api.sesac.co.kr:1207"
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        
        URL(string: baseURL + endpoint)!
        
    }
    
}


