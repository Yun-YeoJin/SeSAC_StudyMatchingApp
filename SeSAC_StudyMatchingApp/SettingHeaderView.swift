//
//  SettingHeaderView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/13.
//

import UIKit

import SnapKit
import Then

class SettingHeaderView: UITableViewHeaderFooterView {
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "profile_img")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let nickNameLabel = UILabel().then {
        $0.text = "윤새싹"
        $0.font = .title1_M16
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let button = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = .gray7
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureUI() {
        
        [imageView, nickNameLabel, button].forEach {
            addSubview($0)
        }
    }
    
    func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(17)
            make.width.height.equalTo(50)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(13)
            make.trailing.lessThanOrEqualTo(button.snp.leading)
            make.height.equalTo(26)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(22.5)
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(44)
        }
    }
}

