//
//  PopupAlertView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/08.
//

import UIKit

import SnapKit
import Then

class PopupAlertView: BaseView {
    
    let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    let titleLabel = UILabel().then {
        $0.text = "정말 탈퇴하시겠습니까?"
        $0.font = .title1_M16
        $0.textAlignment = .center
    }
    
    let subTitleLabel = UILabel().then {
        $0.text = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        $0.numberOfLines = 0
        $0.font = .title4_R14
        $0.textAlignment = .center
    }
    
    let cancelButton = CustomButton().then {
        $0.buttonState = .inactive
        $0.setTitle("취소", for: .normal)
    }
    
    let okButton = CustomButton().then {
        $0.buttonState = .fill
        $0.setTitle("확인", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func titleText(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    override func configureUI() {
        
        self.addSubview(alertView)
        
        [titleLabel, subTitleLabel, cancelButton, okButton].forEach {
            alertView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(self.snp.centerX).offset(-4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        okButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(self .snp.centerX).offset(4)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}

