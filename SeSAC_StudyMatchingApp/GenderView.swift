//
//  GenderView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import SnapKit
import Then

final class GenderView: BaseView {
    
    private let topGenderLabel = UILabel().then {
        $0.text = "성별을 선택해 주세요"
        $0.font = .display1_R20
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let bottomGenderLabel = UILabel().then {
        $0.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        $0.font = .title2_R16
        $0.textColor = .gray7
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    let maleButton = CustomButton().then {
        $0.setImage(UIImage(named: "male"), for: .normal)
        $0.buttonState = .inactive
        $0.clipsToBounds = true
        $0.tag = 0
    }
    
    let femaleButton = CustomButton().then {
        $0.setImage(UIImage(named: "female"), for: .normal)
        $0.buttonState = .inactive
        $0.clipsToBounds = true
        $0.tag = 1
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
        
        [topGenderLabel, bottomGenderLabel, buttonStackView, nextButton].forEach {
            self.addSubview($0)
            
            [maleButton, femaleButton].forEach {
                self.buttonStackView.addArrangedSubview($0)
            }
        }
        [maleButton, femaleButton].forEach { sender in
            sender.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        
        [maleButton, femaleButton].forEach { sender in
            sender.isSelected = false
            sender.backgroundColor = .systemBackground
        }
        sender.isSelected = true
        sender.backgroundColor = .whiteGreen
        
    }
    
    override func setConstraints() {
        
        topGenderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(169)
            make.height.equalTo(32)
        }
        
        bottomGenderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(topGenderLabel.snp.bottom).offset(8)
            make.height.equalTo(32)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(bottomGenderLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(120)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(32)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}


