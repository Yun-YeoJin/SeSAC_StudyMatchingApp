//
//  BirthCustomView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/10.
//

import UIKit

import SnapKit
import Then

class BirthCustomView: BaseView {
    
    let textField = UITextField().then {
        $0.font = .title4_R14
        $0.borderStyle = .none
        $0.textAlignment = .center
        $0.isEnabled = false
    }
    
    let customLabel = UILabel().then {
        $0.font = .title2_R16
        $0.textAlignment = .center
    }
    
    let underlineView = UIView().then {
        $0.backgroundColor = .opaqueSeparator
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        setConstraints()
    }
    
    override func configureUI() {
        
        [textField, customLabel, underlineView].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        textField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(customLabel.snp.leading)
        }
        
        customLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(textField.snp.trailing).offset(4)
            make.width.height.equalTo(20)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).inset(1)
            make.width.equalTo(textField.snp.width)
            make.height.equalTo(1)
            
        }
        
    }
    
}
