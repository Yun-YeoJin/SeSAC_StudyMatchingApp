//
//  UserGenderView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class UserGenderView: BaseView {
    
    let genderLabel = UILabel().then {
        $0.text = "내 성별"
        $0.font = .title4_R14
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let maleButton = CustomButton().then {
        $0.setTitle("남자", for: .normal)
        $0.titleLabel?.font = .body3_R14
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let femaleButton = CustomButton().then {
        $0.setTitle("여자", for: .normal)
        $0.titleLabel?.font = .body3_R14
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
        $0.alignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        
        [genderLabel, stackView].forEach {
            self.addSubview($0)
            
            [maleButton, femaleButton].forEach {
                stackView.addArrangedSubview($0)
            }
        }
        
    }
 
    override func setConstraints() {
        
        genderLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(stackView.snp.leading)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        maleButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(56)
            //make.height.equalTo(48)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.leading.equalTo(maleButton.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(56)
            //make.height.equalTo(48)
        }
        
    }
    
}
