//
//  MatchImage.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/05.
//

import Foundation

enum MatchImage {
    static let antenna = "antenna"
    static let message = "message"
    static let search = "search"
}

enum MatchStatus: Int {
    case antenna = 0
    case message = 1
    case search = 201
}
