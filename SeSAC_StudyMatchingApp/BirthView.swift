//
//  BirthView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import SnapKit
import Then

final class BirthView: BaseView {
    
    private let birthText = UILabel().then {
        $0.text = "생년월일을 알려주세요"
        $0.font = .display1_R20
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let yearTextField = UITextField().then {
        $0.placeholder = "1990"
        $0.font = .title4_R14
        $0.borderStyle = .none
    }
    
    let yearLabel = UILabel().then {
        $0.text = "년"
        $0.font = .title2_R16
    }
    
    let monthTextField = UITextField().then {
        $0.placeholder = "1"
        $0.font = .title4_R14
        $0.borderStyle = .none
    }
    
    let monthLabel = UILabel().then {
        $0.text = "월"
        $0.font = .title2_R16
    }
    
    let dayTextField = UITextField().then {
        $0.placeholder = "1"
        $0.font = .title4_R14
        $0.borderStyle = .none
    }
    
    let dayLabel = UILabel().then {
        $0.text = "일"
        $0.font = .title2_R16
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    
    let nextButton = CustomButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.buttonState = .disable
    }
    
    let datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func configureUI() {
        
        
        [birthText, stackView, nextButton, datePicker].forEach {
            self.addSubview($0)
            
            [yearTextField, yearLabel, monthTextField, monthLabel, dayTextField, dayLabel].forEach {
                self.stackView.addArrangedSubview($0)
            }
        }
    }
    
    override func setConstraints() {
        
        birthText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(169)
            make.height.equalTo(64)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(birthText.snp.bottom).offset(64)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(0)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
}



