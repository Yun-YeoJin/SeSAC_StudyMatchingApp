//
//  BirthViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

class BirthViewModel {
    
    let dateObserver = BehaviorSubject<Date>(value: Date())
    
    let isValid = BehaviorRelay<Bool>(value: false)
    
    var birth: CObservable<Date> = CObservable(Date())
    
    let inputDate = DateFormat(date: Date(), formatString: nil)
    
    let today = DateFormat(date: Date(), formatString: nil)
    
    func checkValidDate(date: Date) -> Bool {
        inputDate.date = date
        birth.value = date
        
        let yearCheck = Calendar.current.dateComponents([.year], from: inputDate.date!, to: today.date!).year ?? 0
        
        if yearCheck >= 17 {
            return true
        } else {
            return false
        }
    }
    


    
}
