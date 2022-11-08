//
//  Login2View.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//


import UIKit

import SnapKit
import Then

final class Login2View: BaseView {
    
    private let loginText = UILabel().then {
        $0.text = "인증번호가 문자로 전송되었어요"
        $0.font = .display1_R20
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let phoneNumber = UITextField().then {
        $0.placeholder = "인증번호 입력"
        $0.font = .title4_R14
        $0.borderStyle = .none
        $0.keyboardType = .numberPad
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .opaqueSeparator
    }
    
    let resendButton = UIButton().then {
        $0.setTitle("재전송", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 10
    }
    
    let getAuthButton = UIButton().then {
        $0.setTitle("인증하고 시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func configureUI() {
        
        
        [loginText, phoneNumber, underlineView, resendButton, getAuthButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        loginText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(169)
            make.height.equalTo(64)
        }
        
        phoneNumber.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(loginText.snp.bottom).offset(64)
            make.trailing.equalTo(resendButton.snp.leading).offset(-8)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumber.snp.bottom).inset(1)
            make.trailing.equalTo(resendButton.snp.leading).offset(-8)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        resendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(loginText.snp.bottom).offset(64)
            make.width.equalTo(72)
            make.height.equalTo(48)
        }
        
        getAuthButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
}

