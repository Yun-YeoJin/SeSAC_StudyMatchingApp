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
import RxCocoa
import RxSwift

final class HomeViewController: BaseViewController {
    
    private let locationManager = CLLocationManager()
    
    var myLocation: CLLocation!
    
    private var sesacCampusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
    
    var currentLocation: CLLocation?
    
    let mainView = HomeView()
    
    let viewModel = HomeViewModel()
    
    var disposeBag = DisposeBag()
    
    var gender: GenderCase = .all
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerSetting()
        moveLocation(latitudeValue: viewModel.lat.value, longtudeValue: viewModel.long.value, delta: 0.005)
        mainView.mapKit.delegate = self
        bindButton()
        bindQueueData()
        
    }
    
    override func configureUI() {
        
        mainView.myLocationButton.addTarget(self, action: #selector(myLocationButtonClicked), for: .touchUpInside)
        mainView.floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: .touchUpInside)
    
    }
    
    func bindButton() {
        
        mainView.searchAllButton.rx.tap
            .subscribe { [self] _ in
                gender = .all
                searchNearSeSAC()
                mainView.searchAllButton.buttonState = .fill
                mainView.searchManButton.buttonState = .inactive
                mainView.searchWomanButton.buttonState = .inactive
            }.disposed(by: disposeBag)
        
        mainView.searchManButton.rx.tap
            .subscribe { [self] _ in
                gender = .man
                searchNearSeSAC()
                mainView.searchAllButton.buttonState = .inactive
                mainView.searchManButton.buttonState = .fill
                mainView.searchWomanButton.buttonState = .inactive
            }.disposed(by: disposeBag)
        
        mainView.searchWomanButton.rx.tap
            .subscribe { [self] _ in
                gender = .woman
                searchNearSeSAC()
                mainView.searchAllButton.buttonState = .inactive
                mainView.searchManButton.buttonState = .inactive
                mainView.searchWomanButton.buttonState = .fill
            }.disposed(by: disposeBag)
        
    }
    
    @objc func floatingButtonClicked() {
        
        searchNearSeSAC()
        transition(KeyWordViewController(), transitionStyle: .push)
    }
    
    @objc func myLocationButtonClicked() {
        
        guard locationManager.location != nil else {
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
    
  
    
}

extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
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
    
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        
        mainView.mapKit.setRegion(pRegion, animated: true)
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        print(#function)
        
        viewModel.lat.accept(mapView.centerCoordinate.latitude)
        viewModel.long.accept(mapView.centerCoordinate.longitude)
        searchNearSeSAC()
        
        findAddress(lat: mapView.centerCoordinate.latitude, long: mapView.centerCoordinate.longitude) { [self] address in
            bindQueueData()
            mapView.markAnnotation(mapView.centerCoordinate, region: false)
        }
    }
    
    func bindQueueData() {
        viewModel.data
            .subscribe(onNext: { [self] data in
                mainView.mapKit.removeAnnotations(mainView.mapKit.annotations)
                mainView.mapKit.markFriendsAnnotation(data.fromQueueDB, filter: gender)
            })
            .disposed(by: disposeBag)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = CustomAnnotation()
        var annotationimageView = UIImageView()
        var image = UIImage()
        
        if annotation.title == "my" {
            annotationimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            image = UIImage(named: "map_marker")!
        } else {
            annotationimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 84, height: 84))
            image = (SesacImage(index: Int(annotation.subtitle! ?? "0")!)?.pageIconImage())!
        }
        
        annotationimageView.image = image
        annotationView.addSubview(annotationimageView)
        annotationView.annotation = annotation
        
        return annotationView
    }
    
    // 주소 찾기
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String) -> ()) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name {
                    completion(name)
                } //전체 주소
            }
        })
    }
    
    func searchNearSeSAC() {
        viewModel.caculateRegion()
        viewModel.searchNearSeSAC { [self] message, code in
            switch code {
            case .userUnexist:
                self.view.makeToast("사용자가 없습니다.")
            default:
                self.view.makeToast("\(code)")
            }
        }
    }
}



