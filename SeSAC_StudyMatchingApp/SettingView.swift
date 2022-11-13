//
//  SettingView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/13.
//

import UIKit

import SnapKit
import Then

final class SettingView: BaseView {
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .plain)
        view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        view.register(SettingHeaderView.self, forHeaderFooterViewReuseIdentifier: "SettingHeaderView")
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        
        [tableView].forEach {
            self.addSubview($0)
        }
    
    }
    
    override func setConstraints() {
        

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
}
