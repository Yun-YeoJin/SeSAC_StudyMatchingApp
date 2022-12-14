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
    case studyRequest
    case studyAccept
    case dodge
    case review
    case chat
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
            return .makeEndpoint("/v1/queue") //새싹 찾기 요청 및 중단
        case .searchSeSAC:
            return .makeEndpoint("/v1/queue/search") //주변 새싹 탐색 기능
        case .checkUserQueueState:
            return .makeEndpoint("/v1/queue/myQueueState") //사용자(본인)의 매칭상태 확인
        case .studyRequest:
            return .makeEndpoint("/v1/queue/studyrequest") //스터디 요청하기
        case .studyAccept:
            return .makeEndpoint("/v1/queue/studyaccept") //스터디 수락하기
        case .dodge:
            return .makeEndpoint("/v1/queue/dodge") //스터디 취소하기
        case .review:
            return .makeEndpoint("/v1/queue/rate/") //리뷰 등록하기
        case .chat:
            return .makeEndpoint("/v1/chat")
        }
    }
    
}

extension URL {
    
    static let baseURL = "http://api.sesac.co.kr:1210"
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        
        URL(string: baseURL + endpoint)!
        
    }
    
}


