//
//  Queue.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/25.
//

import Foundation

// MARK: - Queue
struct Queue: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
//    let dodged, matched, reviewed: Int
//    let matchedNick, matchedUid: String
    let otheruid: String
}

struct NearUserMatch: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String?
}

struct NearUser {
    var lat, long: Double
    var sesac, gender: Int
}

struct NearUserFind {
    
    let uid: String
    let backgroundImage: Int
    let image: Int
    let nickname: String
    let sesacTitle: [Int]
    let comment: [String]
    let studyList: [String]
    
    init(uid: String = "", backgroundImage: Int = 0 , image: Int = 0, nickname: String = "", sesacTitle: [Int] = [], comment: [String] = [], studyList: [String] = []) {
        self.uid = uid
        self.backgroundImage = backgroundImage
        self.image = image
        self.nickname = nickname
        self.sesacTitle = sesacTitle
        self.comment = comment
        self.studyList = studyList
    }
}

