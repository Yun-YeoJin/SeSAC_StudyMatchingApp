//
//  MyInfoView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class MyInfoView: BaseView {
    

    let scrollView = UIScrollView().then {
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = true
    }
    
    let cardView = CardView()
    
    let userGenderView = UserGenderView()
    let favoriteStudyView = FavoriteStudyView()
    let phoneSearchView = PhoneSearchView()
    let friendAgeView = FriendAgeView()
    let withdrawView = WithDrawView()
    
    let stackView = UIStackView().then { // contentsView
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func configureUI() {
        
        self.addSubview(scrollView)
        
        [cardView, stackView].forEach {
            scrollView.addSubview($0)
        }
        
        [userGenderView, favoriteStudyView, phoneSearchView, friendAgeView, withdrawView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        
    }
    
    override func setConstraints() {
        
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
            make.height.equalTo(90)
        }
        
    }
}
