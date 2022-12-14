//
//  NearUserTableViewCell.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/29.
//

import UIKit

import SnapKit
import Then

final class NearUserTableViewCell: BaseTableViewCell {
    
    let cardView = CardView()
    
    let acceptButton = UIButton().then {
        $0.setTitle("요청하기", for: .normal)
        $0.titleLabel?.font = .title4_R14
        $0.backgroundColor = .error
        $0.tintColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureUI() {
    
        self.addSubview(cardView)
        acceptButton.addSubview(cardView)
        
    }
    
    override func setConstraints() {
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
    }
    
}
