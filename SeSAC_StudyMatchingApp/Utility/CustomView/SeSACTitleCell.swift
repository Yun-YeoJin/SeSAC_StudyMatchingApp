//
//  SeSACTitleCell.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class SeSACTitleCell: BaseCollectionViewCell {
    
    let sesacTitleButton = CustomButton().then {
        $0.setTitleColor(.label, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.titleLabel?.font = .title4_R14
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray6.cgColor
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sesacTitleButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    @objc func buttonClicked() {
        
        if sesacTitleButton.isSelected {
            sesacTitleButton.buttonState = .inactive
        } else {
            sesacTitleButton.buttonState = .fill
        }
        
    }
   
    override func prepareForReuse() {
        
        configureUI()
    }

    override func configureUI() {
       
        self.addSubview(sesacTitleButton)
        
        
    }
    
    override func setConstraints() {
        sesacTitleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


