//
//  NickNameView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import SnapKit
import Then

final class NickNameView: BaseView {
    
    private let nickNameText = UILabel().then {
        $0.text = "닉네임을 입력해 주세요"
        $0.font = .display1_R20
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let nickNameTextField = UITextField().then {
        $0.placeholder = "10자 이내로 입력"
        $0.font = .title4_R14
        $0.borderStyle = .none
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .opaqueSeparator
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
        
        
        [nickNameText, nickNameTextField, underlineView, nextButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        nickNameText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(169)
            make.height.equalTo(64)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nickNameText.snp.bottom).offset(64)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(nickNameTextField.snp.bottom).inset(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
    }
    
}


