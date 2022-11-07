//
//  Login1ViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift

final class Login1ViewController: BaseViewController {
    
    let mainView = Login1View()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.getAuthButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.navigationController?.pushViewController(Login2ViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        bind()
    }
    
    func bind() {
        
        mainView.phoneNumber.rx.text.orEmpty
            .changed
            .bind { value in
                self.mainView.phoneNumber.text = self.phoneNumberformat(with: "XXX-XXXX-XXXX", phone: value)
            }
            .disposed(by: disposeBag)
        
    }
    
    func phoneNumberformat(with mask: String, phone: String) -> String {
        
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
        
    }
   
    
}

