//
//  KeyWordCollectionViewCell.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import UIKit

import SnapKit
import Then

final class KeyWordCollectionViewCell: BaseCollectionViewCell {
    
    var cellTapActionHandler: (() -> Void)?
    
    let shellView = UIView()
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    let label = UILabel().then {
        $0.text = "알고리즘"
        $0.textColor = .label
        $0.backgroundColor = .clear
        $0.numberOfLines = 0
        $0.font = .title4_R14
        $0.textAlignment = .center
    }
    
    let button = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .green
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
    }

    
    override func configureUI() {
        
        shellView.layer.borderWidth = 1
        shellView.layer.cornerRadius = 8
        
        addSubview(shellView)
        shellView.addSubview(stackView)
        
    }
    
    override func setConstraints() {
   
        [label, button].forEach {
            stackView.addArrangedSubview($0)
        }
        
        shellView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        label.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
    }
}

extension KeyWordCollectionViewCell {
    @objc func cellTapped() {
        cellTapActionHandler?()
    }
}
