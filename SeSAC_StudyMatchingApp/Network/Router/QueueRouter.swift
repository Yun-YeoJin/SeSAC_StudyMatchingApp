//
//  QueueRouter.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/05.
//

import Foundation
import Alamofire

enum QueueRouter: URLRequestConvertible {
    
    case search(query: String, lat: Double, long: Double)
    case myQueueState(query: String)
    case findPost(query: String, lat: Double, long: Double, list: [String])
    case findDelete(query: String)
    case request(query: String, uid: String)
    case accept(query: String, uid: String)
    case dodge(query: String, uid: String)
    case rate(query: String, uid: String, list: [Int], comment: String)
    
    var baseURL: URL {
        switch self {
        case .search:
            return Endpoint.searchSeSAC.url
        case .myQueueState:
            return Endpoint.checkUserQueueState.url
        case .findPost, .findDelete:
            return Endpoint.requestSearchUser.url
        case .request:
            return Endpoint.studyRequest.url
        case .accept:
            return Endpoint.studyAccept.url
        case .dodge:
            return Endpoint.dodge.url
        case .rate(_, let uid, _, _):
            return URL(string: "\(Endpoint.review.url)" + "\(uid)")!
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        case .myQueueState(let query), .search(let query, _, _), .findPost(let query, _, _, _), .findDelete(let query), .request(query: let query, _), .accept(let query, _), .dodge(let query, _), .rate(let query, _, _, _):
            return  [
                "Content-Type": "application/x-www-form-urlencoded",
                "idtoken": query
            ]
        }
    }
    
    var parameters: Parameters {
        
        switch self {
        case .myQueueState, .findDelete:
            return ["":""]
            
        case .search( _,let lat ,let long):
            return [
                "lat": "\(lat)",
                "long": "\(long)"
            ]
            
        case .findPost( _,let lat ,let long, let list):
            if list.isEmpty {
                return [
                    "lat": "\(lat)",
                    "long": "\(long)",
                    "studylist": "anything"
                ]
            } else {
                return [
                    "lat": "\(lat)",
                    "long": "\(long)",
                    "studylist": list
                ]
            }
            
        case .request( _, let uid), .accept( _, let uid), .dodge( _, let uid):
            return ["otheruid": uid]
            
        case .rate(_ , let uid, let list, let comment):
            return [
                "otheruid": uid,
                "reputation": list,
                "comment": comment
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myQueueState:
            return .get
        case .search, .findPost, .request, .accept, .dodge, .rate:
            return .post
        case .findDelete:
            return .delete
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        switch self {
        case .myQueueState, .findDelete:
            return request
        case .search, .findPost, .request, .accept, .dodge, .rate:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
    }
}
