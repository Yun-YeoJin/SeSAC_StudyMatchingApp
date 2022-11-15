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
        $0.showsUserLocation = true
        $0.setUserTrackingMode(.follow, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        
        [mapKit].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        mapKit.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    
}
