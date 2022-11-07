//
//  Login1View.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class Login1View: BaseView {
    
    
    private let loginText = UILabel().then {
        $0.text = """
        새싹 서비스 이용을 위해
        휴대폰 번호를 입력해 주세요
        """
        $0.font = .display1_R20
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let phoneNumber = UITextField().then {
        $0.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        $0.font = .title4_R14
        $0.borderStyle = .none
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .opaqueSeparator
    }
    
    let getAuthButton = UIButton().then {
        $0.setTitle("인증 문자 받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func configureUI() {
        
        
        [loginText, phoneNumber, underlineView, getAuthButton].forEach {
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
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(loginText.snp.bottom).offset(64)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumber.snp.bottom).inset(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        getAuthButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}
