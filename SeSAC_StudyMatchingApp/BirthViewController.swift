//
//  BirthViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class BirthViewController: BaseViewController {
    
    let mainView = BirthView()
    
    let viewModel = BirthViewModel()
    
    var disposeBag = DisposeBag()
    
    let dateformat = DateFormat(date: Date(), formatString: nil)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configureUI() {
        
        navigationItem.leftBarButtonItem = backBarButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        
        bind()
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {

        mainView.yearTextField.textField.text = changeDateFormatting(date: sender.date, dateFormat: "yyyy")
        mainView.monthTextField.textField.text = changeDateFormatting(date: sender.date, dateFormat: "M")
        mainView.dayTextField.textField.text = changeDateFormatting(date: sender.date, dateFormat: "d")

        changeDateForSave(date: sender.date)

    }
    
    private func bind() {
        
        mainView.datePicker.rx.date
            .bind(to: viewModel.dateObserver)
            .disposed(by: disposeBag)
        
        viewModel.dateObserver
            .map(viewModel.checkValidDate)
            .bind(to: viewModel.isValid)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: { data in
                if data {
                    self.mainView.nextButton.buttonState = .fill
                } else {
                    self.mainView.nextButton.buttonState = .disable
                }
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .bind { value in
                if self.mainView.yearTextField.textField.text!.isEmpty || self.mainView.monthTextField.textField.text!.isEmpty || self.mainView.dayTextField.textField.text!.isEmpty{
                    self.view.makeToast("생년월일을 선택해주세요.", position: .top)
                } else {
                    if self.viewModel.isValid.value {
                        self.navigationController?.pushViewController(EmailViewController(), animated: true)
            
                    } else { //생년월일 조건 오류
                        self.view.makeToast("새싹 스터디는 만 17세 이상만 사용할 수 있습니다.", position: .top)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
   
    
    
   
    
}



