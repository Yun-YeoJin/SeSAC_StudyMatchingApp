
# 🌱 SeSAC Study  - 내 위치 기반 : 매칭 채팅앱

<img width="923" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 53 41" src="https://user-images.githubusercontent.com/106153549/208381402-63b76e30-06a1-4761-8478-d5cbd7c2dc82.png">
<img width="600" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6 05 03" src="https://user-images.githubusercontent.com/106153549/208381906-8b220c54-3312-4ef6-b562-e4f58120dc24.png">



🌱 새싹 iOS 앱 개발자 과정 두 번째 프로젝트 SeSAC Study 입니다.

- **내 위치와 공부하고 싶은 스터디를 바탕으로 주변 사용자와 매칭 후 채팅까지 이어지는 채팅앱**
    - 로그인 및 회원가입
        - 처음 접속 했을 시 OnBoarding 화면
        - FireBaseAuth를 이용한 휴대폰 문자 인증, 로그인, 회원가입
            - 문자 인증 → 로그인 시 가입정보 유무에 따른 화면 전환
            - 회원가입은 닉네임, 생년월일, 이메일, 성별 설정
    - 내 정보 관리
        - 내 정보 관리 수정으로 닉네임, 성별, 내 번호 검색가능, 연령대 설정, 회원탈퇴
            - Custom CardView와 ScrollView를 이용한 화면 구현
            - MultiSlider를 이용한 슬라이더 구현
            - 회원탈퇴시 CustomAlert을 이용해 문구 띄워주기
            - 탈퇴 성공시 → 문자 인증 화면으로 이동 (RootView 변경)
    - 홈 화면
        - MapKit과 CLLocation을 이용한 지도 사용
            - CustomAnnotaion을 이용해 주변 친구들 표시
            - 전체 / 남성 / 여성 필터링 구현
        - 내가 하고 싶은 스터디 설정 후 친구 찾기
    - 채팅 화면
        - 주변 친구 / 받은 요청 목록 확인 후 채팅 구현
            - 채팅 요청 보내기, 수락, 거절
            - 매칭한 친구와 1:1 실시간 채팅
        - 매칭했던 친구 신고, 스터디 취소, 채팅에 대한 리뷰 작성 구현
    - Confluence를 통한 기획 / API 명세서 확인
    - Swagger를 이용한 API MOCK 데이터 확인
    - Figma를 통한 UI 디자인 명세서 확인 및 적용

## **개발 기간 및 사용 기술**

- 개발 기간: 2022.11.07 ~ 2022.12.15 (약 5주) - 기획안 확인, 앱 개발
- 사용 기술:
    - 화면 구현 : Swift, UIKit, SnapKit, Then, Tabman, MultiSlider
    - 네트워크 통신 : Alamofire, RxAlamofire, Router, URLConvertible
    - DB : RealmSwift
    - Rx : RxSwift, RxCocoa, RxKeyboard, RxdataSource
    - 기타 : FireBaseAuth, FCM, Toast, SocketIO
    - 디자인패턴 : MVVM
    

## **새로 배운 것**

- RxAlamofire, Router, URLConvertible를 이용한 비동기 API 통신 및 데이터 처리
    - 자체 서버 API 이용
- MVVM 패턴의 이해 및 적용
- RxSwift에 대한 이해 및 적용
- RxSwift Input / Output을 이용한 MVVM 아키텍처
- WebSocketIO을 이용한 실시간 채팅
- CustomView를 이용한 View 재사용
- Confluence, Figma를 이용한 기획서 확인
- Swagger를 이용한 API MOCK Data 확인
- FireBaseAuth를 이용한 문자 인증 및 로그인
- MapKit, CoreLocation을 이용한 AppleMap 사용

## 💡**Trouble Shooting**

- FireBaseAuth를 이용한 문자 인증 시 → 토큰 갱신 시점 고민
    - 문자인증 후 로그인 할 때 IDToken이 없다면 갱신해주었다.

```swift
func checkValidate(verificationNumber: String, completion: @escaping (VerifyNumberAuthStatus) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID") ?? "", verificationCode: verificationNumber)
        
        Auth.auth().signIn(with: credential) { success, error in
            if let error = error { ... }
            
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                if let error = error {
                    completion(.unknownError)
                    return;
                }
                UserDefaultsRepository.saveIDToken(idToken: idToken ?? "")
                completion(.success)
            })
        }
    }
```

- Firebase 오류 → 회원탈퇴 후 회원가입을 위한 휴대폰 인증시 에러
    - StackOverFlow에서 찾지 못한 내용이라서 FireBase 공식문서를 찾아서 해결
    - `The UIApplicationDelegate must handle remote notification for phone number authentication to work.`

```swift
//AppDelegate에 넣어서 해결함.
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        
    }
```

- 회원탈퇴 후 화면 전환 기능 구현 이슈 (rootView 정해주기)
    - SceneDelegate에서 rootView를 정해주고, 화면 전환시 rootView 수정하기.

```swift
**//ViewController**
			self.viewModel.withdrawUser { message, code in
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                switch code {
                case .success:
                    let vc = Login1ViewController()
                    sceneDelegate?.window?.rootViewController = vc
                    sceneDelegate?.window?.makeKeyAndVisible()
                default:
                    self.view.makeToast("회원탈퇴에 실패했어요.")
                }
            }
```

- 뒤로가기 버튼 클릭 시 바로 전 화면이 아닌 원하는 화면으로 Pop 기능이슈

```swift
**//extension UIViewController**		
func navigationPopToViewController<T: UIViewController>(_ vc: T) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]

        for viewController in viewControllers {
            if let rootVC = viewController as? T {
                self.navigationController?.popToViewController(rootVC, animated: true)
            }
        }
    }
```

- 생년월일 DatePicker 만 17세 이상 버튼 활성화 - dateComponents를 이용

```swift
**//ViewModel**
func checkValidDate(date: Date) -> Bool {
        
	 inputDate.date = date
	 birth.value = date
        
	 let yearCheck = Calendar.current.dateComponents([.year], from: inputDate.date!, to: today.date!).year ?? 0
        
   return yearCheck >= 17
}

```

- Mapkit과 CLLocation을 이용한 CustomAnnotaion 설정 이슈

```swift
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else {return nil}
        guard let annotationView = mainView.mapKit.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier) as? CustomAnnotationView else { return nil }
        annotationView.annotation = annotation
        
        let size = CGSize(width: 95, height: 95)
        UIGraphicsBeginImageContext(size)
        
        let image = UIImage.sesacImage(num: annotation.image ?? 0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = resizedImage
        UIGraphicsEndImageContext()
        return annotationView
    }

func setRegionAnnotation(center: CLLocationCoordinate2D, users: [SeSACUser]) {
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapKit.removeAnnotations(mainView.mapKit.annotations)
        mainView.mapKit.setRegion(region, animated: false)

        var annotation: [CustomAnnotation] = []
        
        for user in users {
            let point = CustomAnnotation(image: user.sesac, coordinate: CLLocationCoordinate2D(latitude: user.lat, longitude: user.long))
            annotation.append(point)
        }
        mainView.mapKit.addAnnotations(annotation)
    }

```

- 내 정보 관리에서 ScrollView 이슈 → ScrollView 내에 ContentsView 없이 레이아웃을 잡게되면 ScrollView 내부의 크기를 제대로 잡지 못해서 Scroll이 되지 않는 이슈가 발생 → ScrollView의 공식문서, 블로그등으로 찾아서 이해하고 적용
    - ScrollView안에 들어가는 ContentsView가 ScrollView에 제약 조건을 걸어야 한다.
    - ContentsView를 equalToSuperView()에 제약조건을 걸면 스크롤이 동작하지 않는다.

```swift

		let scrollView = UIScrollView()
    let cardView = CardView()
    let stackView = UIStackView()

    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.leading.equalTo(scrollView).inset(16)
            make.trailing.equalTo(scrollView).inset(16)
            make.height.greaterThanOrEqualTo(252)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(10)
            make.leading.equalTo(scrollView).inset(16)
            make.trailing.equalTo(scrollView).inset(16)
            make.bottom.equalTo(scrollView)
        }
				... 
```

## **UI**

<img width="652" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 51 46" src="https://user-images.githubusercontent.com/106153549/208381632-f3416667-8c64-450b-bc6f-82f975edee99.png">
<img width="865" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 51 52" src="https://user-images.githubusercontent.com/106153549/208381713-2e81410b-37e7-40c6-8832-f81d368fa07b.png">
<img width="645" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 51 37" src="https://user-images.githubusercontent.com/106153549/208381990-331a9c93-2d9f-48b5-be72-c9217b09a097.png">
<img width="864" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 51 31" src="https://user-images.githubusercontent.com/106153549/208382020-f06d3b76-2f48-41b9-9fbb-de2b35ffba5b.png">
<img width="251" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 51 21" src="https://user-images.githubusercontent.com/106153549/208382033-9715653f-dae5-4403-8c87-7a1f7ab2b7c3.png">
<img width="912" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6 06 29" src="https://user-images.githubusercontent.com/106153549/208382108-4eca2010-ba21-4556-89d1-c630f59f6d04.png">
