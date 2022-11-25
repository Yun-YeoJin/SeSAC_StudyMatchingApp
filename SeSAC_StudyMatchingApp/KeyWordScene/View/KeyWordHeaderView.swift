//
//  KeyWordHeaderView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import UIKit
import SnapKit
import Then

final class KeyWordHeaderView: UICollectionReusableView {
    
    let HeaderLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title6_R12
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureUI() {
        addSubview(HeaderLabel)
    }
    
    func setConstraints() {
        HeaderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
