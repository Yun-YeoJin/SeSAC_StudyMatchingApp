//
//  ChattingSectionModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/06.
//

import Foundation

import RxDataSources

struct ChattingSectionModel {
    var items: [Item]
}

extension ChattingSectionModel: SectionModelType {
    
    typealias Item = NearUserChat
    
    init(original: ChattingSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
