//
//  SettingTableViewCell.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/13.
//

import UIKit

import SnapKit
import Then

final class SettingTableViewCell: BaseTableViewCell {

    let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
    }
    
    let titleLabel = UILabel().then {
        $0.font = .title2_R16
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    override func configureUI() {
        
        [iconImageView, titleLabel].forEach {
            self.addSubview($0)
        }
        
    }

    override func setConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(17)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(14)
            make.height.equalTo(20)
        }
        
    }
   
    func cellConfiguration(row: Int) {

        switch row {
        case 0:
            titleLabel.text = "공지사항"
            iconImageView.image = UIImage(named: "notice")
        case 1:
            titleLabel.text = "자주 묻는 질문"
            iconImageView.image = UIImage(named: "faq")
        case 2:
            titleLabel.text = "1:1 문의"
            iconImageView.image = UIImage(named: "qna")
        case 3:
            titleLabel.text = "알림 설정"
            iconImageView.image = UIImage(named: "setting_alarm")
        case 4:
            titleLabel.text = "이용 약관"
            iconImageView.image = UIImage(named: "permit")
        default:
            titleLabel.text = "default"
            iconImageView.image = UIImage(systemName: "person.fill")
        }
    }
}



