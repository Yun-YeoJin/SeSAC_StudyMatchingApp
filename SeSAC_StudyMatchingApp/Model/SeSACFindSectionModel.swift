//
//  SeSACFindSectionModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/08.
//

import Foundation

import RxDataSources

struct SeSACFindSectionModel {
    var items: [Item]
}

extension SeSACFindSectionModel: SectionModelType {
    
    typealias Item = NearUserFind
    
    init(original: SeSACFindSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
