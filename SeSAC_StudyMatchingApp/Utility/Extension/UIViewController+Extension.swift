//
//  UIViewController+Extension.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/10.
//

import UIKit

extension UIViewController {
    
    func changeDateFormatting(date: Date, dateFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
        
    }
    
    func changeDateForSave(date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let new = dateFormatter.string(from: date)
        print(new)
        
        UserDefaultsRepository.saveBirth(birth: new)
    }
    
}
