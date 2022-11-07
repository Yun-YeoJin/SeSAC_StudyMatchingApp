//
//  UIFont+Extension.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

struct Font {
    
    static let notoSansKR_Regular = "NotoSansKR-Regular"
    static let notoSansKR_Medium = "NotoSansKR-Medium"
    
}

extension UIFont {

    static var display1_R20: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 20)!
    }
    static var title1_M16: UIFont {
        UIFont(name: Font.notoSansKR_Medium, size: 16)!
    }
    static var title2_R16: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 16)!
    }
    static var title3_M14: UIFont {
        UIFont(name: Font.notoSansKR_Medium, size: 14)!
    }
    static var title4_R14: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 14)!
    }
    static var title5_M12: UIFont {
        UIFont(name: Font.notoSansKR_Medium, size: 12)!
    }
    static var title6_R12: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 12)!
    }
    static var body1_M16: UIFont {
        UIFont(name: Font.notoSansKR_Medium, size: 16)!
    }
    static var body2_R16: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 16)!
    }
    static var body3_R14: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 14)!
    }
    static var body4_R12: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 12)!
    }
    static var caption_R10: UIFont {
        UIFont(name: Font.notoSansKR_Regular, size: 10)!
    }
}
