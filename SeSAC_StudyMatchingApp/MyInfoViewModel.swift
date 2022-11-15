//
//  MyInfoViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import Foundation

import RxCocoa
import RxSwift

class MyInfoViewModel {
    
    let title = BehaviorRelay<[String]>(value: ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"])
    
}
