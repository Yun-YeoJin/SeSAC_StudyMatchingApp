//
//  HomeView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/15.
//

import UIKit

import SnapKit
import Then
import MapKit

final class HomeView: BaseView {
    
    let mapKit = MKMapView().then {
        $0.mapType = MKMapType.standard
        $0.setUserTrackingMode(.follow, animated: true)
        $0.isZoomEnabled = true
        $0.isRotateEnabled = false
    }
    
    let genderButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let searchAllButton = CustomButton().then {
        $0.setTitle("전체", for: .normal)
        $0.buttonState = .fill
        $0.titleLabel?.font = .title3_M14
        $0.layer.cornerRadius = 0
        $0.tag = GenderCase.all.rawValue
    }
    
    let searchManButton = CustomButton().then {
        $0.setTitle("남자", for: .normal)
        $0.buttonState = .inactive
        $0.titleLabel?.font = .title3_M14
        $0.layer.cornerRadius = 0
        $0.tag = GenderCase.man.rawValue
    }
    
    let searchWomanButton = CustomButton().then {
        $0.setTitle("여자", for: .normal)
        $0.buttonState = .inactive
        $0.titleLabel?.font = .title3_M14
        $0.layer.cornerRadius = 0
        $0.tag = GenderCase.woman.rawValue
    }
    
    let floatingButton = UIButton().then {
        $0.setImage(UIImage(named: "floatingButton_default"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = $0.frame.size.width / 2
    }
    
    let myLocationButton = CustomButton().then {
        $0.setImage(UIImage(named: "bt_gps"), for: .normal)
        $0.backgroundColor = .white
        $0.buttonState = .inactive
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func configureUI() {
        
        [mapKit,genderButtonStackView, floatingButton, myLocationButton].forEach {
            self.addSubview($0)
            
            [searchAllButton, searchManButton, searchWomanButton].forEach {
                genderButtonStackView.addArrangedSubview($0)
            }
        }
    }
    
    override func setConstraints() {
        
        mapKit.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    
        floatingButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(64)
        }
        
        genderButtonStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        searchManButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(genderButtonStackView.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(48)
        }
        
        
    }
    
    
}
