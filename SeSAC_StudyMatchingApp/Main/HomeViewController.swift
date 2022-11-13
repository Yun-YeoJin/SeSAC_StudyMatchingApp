//
//  HomeViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import CoreLocation

final class HomeViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()
    
    var lat: Double = 37.517829 //새싹 영등포 캠퍼스 주소를 Default로 하겠다.
    var lon: Double = 126.886270
    
    private var myLocation = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            lat = coordinate.latitude
            lon = coordinate.longitude
            
            myLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            //API 통신 이용해서 위치 얻어와야함.
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        checkLocationServiceAuthorizationStatus()
    }
    
    func checkLocationServiceAuthorizationStatus() {
                
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
                
        checkCurrentLocationAuthorizationStatus(authorizationStatus)
                        
    }
    
    func checkCurrentLocationAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            
        default:
            print("항상 허용")
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            //설정페이지로 가는링크
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}
