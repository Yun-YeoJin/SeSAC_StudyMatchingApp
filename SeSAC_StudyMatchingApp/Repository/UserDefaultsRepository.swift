//
//  UserDefaultsRepository.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/09.
//

import Foundation

final class UserDefaultsRepository {
    
    //MARK: Save
    static func checkSecondRun(check: Bool) {
        UserDefaults.standard.set(check, forKey: UserDefaultKey.secondRun)
    }

    static func saveAuthVerificationID(authVerificationID: String) {
        UserDefaults.standard.set(authVerificationID, forKey: UserDefaultKey.authVerificationID)
    }
    
    static func saveidForCredentialFirebase(credentialId: String) {
        UserDefaults.standard.set(credentialId, forKey: UserDefaultKey.credentialId)
    }

    static func saveFCMToken(fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKey.fcmToken)
    }

    static func saveIDToken(idToken: String) {
        UserDefaults.standard.set(idToken, forKey: UserDefaultKey.idToken)
    }

    static func savePhoneNumber(phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: UserDefaultKey.phoneNumber)
    }

    static func saveNickname(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultKey.nickname)
    }

    static func saveBirth(birth: String) {
        UserDefaults.standard.set(birth, forKey: UserDefaultKey.birth)
    }

    static func saveEmail(email: String) {
        UserDefaults.standard.set(email, forKey: UserDefaultKey.email)
    }

    static func saveGender(gender: Int) {
        UserDefaults.standard.set(gender, forKey: UserDefaultKey.gender)
    }
    
    
    //MARK: Fetch
    static func fetchSecondRun() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKey.secondRun)
    }
    
   
    
    static func fetchAuthVerificationID() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.authVerificationID) ?? ""
    }
    
    static func fetchCredentialIdForFirebase() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.credentialId) ?? ""
    }
    
    static func fetchFCMToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken) ?? ""
    }
    
    static func fetchPhoneNumber() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.phoneNumber)!
    }

    static func fetchUserNickname() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname)!
    }
    
    static func fetchUserBirth() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.birth)!
    }
    
    static func fetchUserEmail() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.email)!
    }
    
    static func fetchUserGender() -> Int {
        return UserDefaults.standard.integer(forKey: UserDefaultKey.gender)
    }

    static func fetchUserIDToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.idToken) ?? ""
    }

}
