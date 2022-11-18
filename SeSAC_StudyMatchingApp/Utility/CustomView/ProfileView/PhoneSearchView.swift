//
//  PhoneSearchView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import UIKit

import SnapKit
import Then


final class PhoneSearchView: BaseView {
    
    let phoneNumberLabel = UILabel().then {
        $0.text = "내 번호 검색 허용"
        $0.font = .title4_R14
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let phoneNumberSwitch = UISwitch().then {
        $0.backgroundColor = .clear
        $0.onTintColor = .green
        $0.tintColor = .gray4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        [phoneNumberLabel, phoneNumberSwitch].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraints() {
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
        }
        
        phoneNumberSwitch.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(16)
            make.height.equalTo(28)
            make.width.equalTo(52)
        }
        
    }
    
}
