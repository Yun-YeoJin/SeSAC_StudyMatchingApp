//
//  EmailView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import SnapKit
import Then

final class EmailView: BaseView {
    
    
    private let topEmailLabel = UILabel().then {
        $0.text = "이메일을 입력해 주세요"
        $0.font = .display1_R20
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let bottomEmailLabel = UILabel().then {
        $0.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        $0.font = .title2_R16
        $0.textColor = .gray7
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "SeSAC@email.com"
        $0.font = .title4_R14
        $0.borderStyle = .none
        $0.keyboardType = .emailAddress
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    let nextButton = CustomButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.buttonState = .disable
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func configureUI() {
        
        
        [topEmailLabel, bottomEmailLabel, emailTextField, underlineView, nextButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        topEmailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(169)
            make.height.equalTo(32)
        }
        
        bottomEmailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(topEmailLabel.snp.bottom).offset(8)
            make.height.equalTo(32)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(bottomEmailLabel.snp.bottom).offset(64)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.bottom).inset(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}

