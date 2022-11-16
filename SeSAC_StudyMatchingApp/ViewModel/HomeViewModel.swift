//
//  HomeViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import Foundation

class HomeViewModel {
    
    var centerLat = CObservable(0.0)
    var centerLong = CObservable(0.0)
    var centerRegion = CObservable(0)
    
    func calculateRegion(lat: Double, long: Double) {
        
        centerLat.value = lat
        centerLong.value = long
        
        var strLat = String(lat+90)
        var strLong = String(long+180)
        
        strLat = strLat.components(separatedBy: ["."]).joined()
        strLong = strLong.components(separatedBy: ["."]).joined()
        
        let strRegion = strLat.substring(from: 0, to: 4) + strLong.substring(from: 0, to: 4)
        
        centerRegion.value = Int(strRegion) ?? 0
        
    }
    
    
}
