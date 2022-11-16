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
    
    public func showAlert(title: String, message: String, buttonTitle: String, buttonAction: @escaping ((UIAlertAction) -> Void )) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: buttonTitle, style: .destructive, handler: buttonAction)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
