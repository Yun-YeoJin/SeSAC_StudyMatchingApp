//
//  NearUserViewModel.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/05.
//

import Foundation
import CoreLocation

import FirebaseAuth
import RxSwift
import RxCocoa

final class NearUserViewModel {
    
    let disposeBag = DisposeBag()
    
    var locationValue: CLLocationCoordinate2D?
    
    var searchSesac = PublishRelay<Bool>()
    
    var match = PublishSubject<NearUserMatch>()
    var matchError = PublishRelay<Bool>()
    
    func requsetSearch(output: Output) {
        
        guard let location = locationValue else {return}
        
        SeSACAPIService.shared.requestSeSACAPI(type: Queue.self ,router: QueueRouter.search(query: UserDefaultsRepository.fetchUserIDToken(), lat: location.latitude, long: location.longitude)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                output.sesacInfo.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenInvalid:
                    self.updateIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requsetSearch(output: output)
                    }
                default:
                    output.networkFailed.accept(true)
                }
            }
        }
    }

    func requestFindDelete(completion: @escaping (Int) -> Void) {
        SeSACAPIService.shared.requestStatusSeSACAPI(router: QueueRouter.findDelete(query: UserDefaultsRepository.fetchUserIDToken())) { value in
            completion(value)
        }
    }
    
    func requestMYQueue() {
        
        SeSACAPIService.shared.requestSeSACAPI(type: NearUserMatch.self, router: QueueRouter.myQueueState(query: UserDefaultsRepository.fetchUserIDToken())) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let success):
                self.match.onNext(success)
            case .failure(let fail):
                let error = fail as! SeSACError
                switch error {
                case .firebaseTokenInvalid:
                    self.updateIdToken { [weak self] in
                        guard let self = self else {return}
                        self.requestMYQueue()
                    }
                default:
                    self.matchError.accept(true)
                }
            }
        }
    }
    
    func updateIdToken(completion: @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                return
            }
            if let idToken = idToken {
                UserDefaultsRepository.saveIDToken(idToken: idToken)
                completion()
            }
        }
    }
}

extension NearUserViewModel {
    
    struct Input {
        let reload: ControlEvent<Void>
        let change: ControlEvent<Void>
        let refresh: ControlEvent<Void>
        let tableItem: ControlEvent<IndexPath>
    }
    
    struct Output {
        var sesacInfo = PublishSubject<Queue>()
        var networkFailed = PublishRelay<Bool>()
        var searchSesac: PublishRelay<Bool>
        let reload: ControlEvent<Void>
        let change: ControlEvent<Void>
        let refresh: ControlEvent<Void>
        let tableItem: ControlEvent<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchSesac: searchSesac, reload: input.reload, change: input.change, refresh: input.refresh, tableItem: input.tableItem)
        
        return output
    }
}

