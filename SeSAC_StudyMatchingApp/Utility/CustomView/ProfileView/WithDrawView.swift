//
//  WithDrawView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class WithDrawView: BaseView {
    
    let withdrawButton = CustomButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = .title4_R14
        $0.backgroundColor = .clear
        $0.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        [withdrawButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        withdrawButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
    }
    
}
