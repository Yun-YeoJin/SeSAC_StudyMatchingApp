//
//  FriendAgeView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import UIKit

import SnapKit
import Then
import MultiSlider

final class FriendAgeView: BaseView {
    
    let ageLabel = UILabel().then {
        $0.text = "상대방 연령대"
        $0.font = .title4_R14
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let ageValueLabel = UILabel().then {
        $0.text = "18 - 65"
        $0.textColor = .green
        $0.font = .title4_R14
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    
    let ageSlider = MultiSlider().then {
        $0.minimumValue = 18
        $0.maximumValue = 65
        $0.outerTrackColor = .gray7
        $0.backgroundColor = .clear
        $0.tintColor = .green
        $0.orientation = .horizontal
        $0.thumbImage = UIImage(named: "filter_control")
        $0.thumbCount = 2
        $0.thumbImage = UIImage(named: "filter_control")
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ageSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderChanged(_ sender: MultiSlider) {
        
        let minAge = Int(sender.value[0])
        let maxAge = Int(sender.value[1])
        
        ageValueLabel.text = "\(minAge) - \(maxAge)"
        
    }
    
    override func configureUI() {
        
        [ageLabel, ageValueLabel, ageSlider].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        ageLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        
        ageValueLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.leading.lessThanOrEqualTo(ageLabel.snp.trailing).offset(16)
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    
}
