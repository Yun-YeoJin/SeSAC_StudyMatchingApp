//
//  HomeViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import CoreLocation
import MapKit
import Toast

final class HomeViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()
    
    var lat: Double = 37.517829 //새싹 영등포 캠퍼스 주소를 Default로 하겠다.
    var lon: Double = 126.886270
    
    var myLocation: CLLocation!
    
    private var sesacCampusLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    let mainView = HomeView()
    
    let viewModel = HomeViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManagerSetting()
        mapKitSetting()
        
        
    }
    
    override func configureUI() {
        
        mainView.myLocationButton.addTarget(self, action: #selector(myLocationButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func myLocationButtonClicked() {
        
        guard let currentLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            showRequestLocationServiceAlert()
            return
        }
        
        mainView.mapKit.showsUserLocation = true
        mainView.mapKit.setUserTrackingMode(.follow, animated: true)
        
    }
    
    private func locationManagerSetting() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 권한 요청
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        myLocation = locationManager.location
    }
    
    private func mapKitSetting() {
        
        mainView.mapKit.setRegion(MKCoordinateRegion(center: sesacCampusLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true) // 현재 지도 상태를 set(위치, 축척)
        
        mainView.mapKit.delegate = self
        
    }

}

extension HomeViewController: CLLocationManagerDelegate {
    
    // MARK: iOS 버전에 따른 분기 처리와 iOS 위치 서비스 여부 확인
    func checkUserLocationServiceAuthoriztaion() {
        
        let authorizationStatus : CLAuthorizationStatus
        
        if #available(iOS 14.0, *){
            authorizationStatus = locationManager.authorizationStatus // iOS 14이상에서만 사용이 가능
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()  // 14미만
        }
        
        // iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            // 권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
            
        } else {
            view.makeToast("위치 서비스를 켜주세요")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            lat = coordinate.latitude
            lon = coordinate.longitude
            
            sesacCampusLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            
            print("LocationDisable")
            showRequestLocationServiceAlert()
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("LocationEnable")
            
            locationManager.startUpdatingLocation()
            
        @unknown default:
            print("unknown")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
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

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        print(#function)
        
        let lat = mainView.mapKit.centerCoordinate.latitude
        let long = mainView.mapKit.centerCoordinate.longitude
        
        viewModel.calculateRegion(lat: lat, long: long)
        
    }
    
}


