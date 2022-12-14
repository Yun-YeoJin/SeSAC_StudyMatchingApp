//
//  FirebaseRepository.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/10.
//

import UIKit

import Alamofire
import Firebase
import FirebaseAuth
import RxSwift
import RxAlamofire

final class FirebaseRepository {
    
    var disposeBag = DisposeBag()
    
    static let shared = FirebaseRepository()
    
    func checkValidate(verificationNumber: String, completion: @escaping (VerifyNumberAuthStatus) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID") ?? "", verificationCode: verificationNumber)
        
        Auth.auth().signIn(with: credential) { success, error in
            if let error = error {
                if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errorCode {
                    case .invalidVerificationCode:
                        completion(.wrongVerificationNumber)
                    default:
                        completion(.unknownError)
                    }
                }
                return
            }
            
            let currentUser = Auth.auth().currentUser
            
            currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                if let error = error {
                    print(#function, error)
                    completion(.unknownError)
                    return;
                }
                //UserDefaults.standard.set(idToken, forKey: "idToken")
                UserDefaultsRepository.saveIDToken(idToken: idToken ?? "")
                
                completion(.success)
            })
        }
    }
    
    //MARK: 6자리 코드 인증
    static func signInWithCredential(verificationId: String, verificationCode: String) -> Single<String> {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode
        )
        
        return Single.create { single in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    single(.failure(error))
                }
                
                single(.success(""))
            }
            return Disposables.create()
        }
    }
    
    
    func getIdToken(completion: @escaping (VerifyNumberAuthStatus) -> Void) {
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
            if let error = error {
                print(#function, error)
                completion(.unknownError)
                return;
            }
        
            UserDefaultsRepository.saveIDToken(idToken: idToken!)
            
            completion(.success)
        })
    }
    
    func updateFCMToken(completion: @escaping (UserEnum) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaultsRepository.fetchUserIDToken()
        ]
        
        let parameters: [String: Any] = [
            "FCMtoken": UserDefaultsRepository.fetchFCMToken()
        ]
        
        RxAlamofire.requestData(.put, Endpoint.updateFCMToken.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                if apiState == .firebaseTokenInvalid {
                    self.getIdToken { code in
                        print(code)
                    }
                }
                
                completion(apiState)
            }
            .disposed(by: disposeBag)
        
    }

}
