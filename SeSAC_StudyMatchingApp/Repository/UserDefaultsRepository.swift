//
//  UserDefaultsRepository.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/09.
//

import Foundation

final class UserDefaultsRepository {
    
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
    
    static func fetchSecondRun() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKey.secondRun)
    }

    static func fetchUserNickname() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname)!
    }

    static func fetchCredentialIdForFirebase() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.credentialId)!
    }

    static func fetchUserIDToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKey.idToken)!
    }

    
}
