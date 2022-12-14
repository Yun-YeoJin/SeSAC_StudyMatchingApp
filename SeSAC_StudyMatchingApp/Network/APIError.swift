//
//  APIError.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/25.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
}

enum SeSACError: Int, Error {
    
    case userExist = 201 //이미 존재하는 유저
    case invalidNickname = 202 //사용할 수 없는 닉네임
    case firebaseTokenInvalid = 401 //파이어베이스 토큰 에러
    case userUnexist = 406 //미가입 회원
    case serverError = 500 //서버 에러
    case clientError = 501 //클라이언트 에러
    
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

enum SearchQueueEnum: Int {
    
    case success = 200 //친구 찾기 요청 성공
    case bannedUser = 201 //신고 3번 이상 받은 유저
    case studyCancelPenalty1 = 203 //스터디 취소 페널티 1단계
    case studyCancelPenalty2 = 204 //스터디 취소 페널티 2단계
    case studyCancelPenalty3 = 205 //스터치 취소 페널티 3단계
    case firebaseTokenInvalid = 401 //파이어베이스 토큰 에러
    case userUnexist = 406 //미가입 회원
    case serverError = 500 //서버 에러
    case clientError = 501 //클라이언트 에러
    
}

enum QueueStateEnum: Int {
    
    case success = 200 //매칭 상태 확인 성공
    case normal = 201 //스터디 찾기를 요청하지 않는, 일반상태
    case firebaseTokenInvalid = 401 //파이어베이스 토큰 에러
    case userUnexist = 406 //미가입 회원
    case serverError = 500 //서버 에러
    case clientError = 501 //클라이언트 에러
    
}

enum StudyRequestEnum: Int {
    
    case success = 200 //스터디 요청 성공
    case alreadySendRequest = 201 //상대방이 이미 나에게 스터디 요청한 상태
    case cancelSearch = 202 //상대방이 새싹 찾기를 중단한 상태
    case firebaseTokenInvalid = 401 //파이어베이스 토큰 에러
    case userUnexist = 406 //미가입 회원
    case serverError = 500 //서버 에러
    case clientError = 501 //클라이언트 에러
    
}

enum StudyAcceptEnum: Int {
    
    case success = 200 //스터디 수락 성공
    case alreadyMatched = 201 //상대방이 이미 다른 사용자와 매칭된 상태
    case cancelSearch = 202 //상대방이 새싹 찾기를 중단한 상태
    case alreadyAccepted = 203 //내가 이미 다른 사용자와 매칭된 상태
    case firebaseTokenInvalid = 401 //파이어베이스 토큰 에러
    case userUnexist = 406 //미가입 회원
    case serverError = 500 //서버 에러
    case clientError = 501 //클라이언트 에러
    
}




