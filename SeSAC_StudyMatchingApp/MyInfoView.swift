//
//  MyInfoView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyInfoView: BaseView {
 
    let cardView = CardView()
    
    let userGenderView = UserGenderView()
    let favoriteStudyView = FavoriteStudyView()
    let phoneSearchView = PhoneSearchView()
    let friendAgeView = FriendAgeView()
    let withdrawView = WithDrawView()

    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configureUI() {
        
        [cardView, stackView].forEach {
            self.addSubview($0)
            
            [userGenderView, favoriteStudyView, phoneSearchView, friendAgeView, withdrawView].forEach {
                stackView.addArrangedSubview($0)
            }
        }
        
    }
    
    override func setConstraints() {
        
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.height.greaterThanOrEqualTo(250)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(0)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        userGenderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
        }
        favoriteStudyView.snp.makeConstraints { make in
            make.top.equalTo(userGenderView.snp.bottom)
            make.height.equalTo(60)
        }
        phoneSearchView.snp.makeConstraints { make in
            make.top.equalTo(favoriteStudyView.snp.bottom)
            make.height.equalTo(60)
        }
        friendAgeView.snp.makeConstraints { make in
            make.top.equalTo(phoneSearchView.snp.bottom)
            make.height.equalTo(90)
        }
        withdrawView.snp.makeConstraints { make in
            make.top.equalTo(friendAgeView.snp.bottom)
            make.height.equalTo(60)
        }
        
       
    }
}
