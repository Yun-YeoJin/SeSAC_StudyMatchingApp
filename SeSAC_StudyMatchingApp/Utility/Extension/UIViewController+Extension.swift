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
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        return dateFormatter.string(from: date)
        
    }
    
    func changeDateForSave(date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let newDate = dateFormatter.string(from: date)
        print(newDate)
        
        UserDefaultsRepository.saveBirth(birth: newDate)
    }
    
}
