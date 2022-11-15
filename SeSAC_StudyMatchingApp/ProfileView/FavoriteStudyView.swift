//
//  FavoriteStudyView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class FavoriteStudyView: BaseView {
    
    let studyLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "자주 하는 스터디"
        $0.font = .title4_R14
        $0.numberOfLines = 0
    }
    
    let studyTextField = UITextField().then {
        $0.placeholder = "스터디를 입력해주세요"
    }
    
    let underlineView = UIView().then {
        $0.backgroundColor = .opaqueSeparator
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        studyTextField.delegate = self
        
    }
    
    override func configureUI() {
        [studyLabel, studyTextField, underlineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        studyLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(studyTextField.snp.leading).offset(20)
            make.height.equalTo(44)
        }
        
        studyTextField.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(16)
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(studyTextField.snp.bottom).inset(1)
            make.leading.equalTo(studyTextField.snp.leading)
            make.trailing.equalTo(studyTextField.snp.trailing)
            make.height.equalTo(1)
        }
        
    }
    
}

extension FavoriteStudyView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}
