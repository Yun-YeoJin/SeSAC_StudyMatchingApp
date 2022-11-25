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
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
    let otheruid: String
}

