//
//  SeSACImage.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/28.
//

import UIKit

enum SesacImage {
    case user
    case level1
    case level2
    case level3
    case level4
    case level5
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .level1
        case 1:
            self = .level2
        case 2:
            self = .level3
        case 3:
            self = .level4
        case 4:
            self = .level5
        case 5:
            self = .user
        default:
            return nil
        }
    }
    
    func pageIconImage() -> UIImage {
        switch self {
        case .user:
            return UIImage(named: "map_marker")!
        case .level1:
            return UIImage(named: "sesac_face_1")!
        case .level2:
            return UIImage(named: "sesac_face_2")!
        case .level3:
            return UIImage(named: "sesac_face_3")!
        case .level4:
            return UIImage(named: "sesac_face_4")!
        case .level5:
            return UIImage(named: "sesac_face_5")!
        }
    }
    
}
