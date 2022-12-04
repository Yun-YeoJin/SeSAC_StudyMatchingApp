//
//  EmptyReceiveRequestView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/04.
//

import UIKit

import SnapKit
import Then

final class EmptyReceiveRequestView: BaseView {
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "request_empty_img")
        $0.backgroundColor = .clear
    }
    
    let changeStudyButton = CustomButton().then {
        $0.setTitle("스터디 변경하기", for: .normal)
        $0.buttonState = .fill
        $0.titleLabel?.font = .title4_R14
    }
    
    let refreshButton = CustomButton().then {
        $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        $0.buttonState = .outline
    }
    
    let ButtonView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    override func configureUI() {
   
        [imageView, ButtonView].forEach {
            self.addSubview($0)
        }
        
        [changeStudyButton, refreshButton].forEach {
            ButtonView.addSubview($0)
        }
        
    
    }
    
    override func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(170)
        }
        
        ButtonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
        
        changeStudyButton.snp.makeConstraints { make in
            make.width.equalTo(287)
            make.leading.equalToSuperview().inset(10)
            make.bottom.top.equalToSuperview()
        }
        
        refreshButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.top.equalTo(changeStudyButton.snp.top)
            make.leading.equalTo(changeStudyButton.snp.trailing).offset(10)
        }
    }
}
