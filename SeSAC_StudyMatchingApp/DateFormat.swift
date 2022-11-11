//
//  DateFormat.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/11.
//

import Foundation

class DateFormat {
    
    let dateFormatter = DateFormatter()
    var date: Date?
    var formatString: String?
    
    final var dateStr: String {
        get {
            let value = changeDateFormatting(date: date!, dateFormat: formatString!)
            return value
        }
    }

    final var yearStr: String {
        get {
            let value = changeDateFormatting(date: date!, dateFormat: "yyyy")
            return value
        }
    }

    final var monthStr: String {
        get {
            let value = changeDateFormatting(date: date!, dateFormat: "M")
            return value
        }
    }

    final var dayStr: String {
        get {
            let value = changeDateFormatting(date: date!, dateFormat: "d")
            return value
        }
    }

    init(date: Date, formatString: String?) {
        self.date = date
        self.formatString = formatString
    }
                                    
    func changeDateFormatting(date: Date, dateFormat: String) -> String {
        
        dateFormatter.dateFormat = formatString
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }
    
}
