//
//  OnBoardingCollectionViewCell.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class OnBoardingCollectionViewCell: BaseCollectionViewCell {
    
    let textImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    let onboardingImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        

    }
    
    override func configureUI() {
        
        contentView.addSubview(textImageView)
        contentView.addSubview(onboardingImageView)
        
    }
    
    override func setConstraints() {
        
        textImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(77)
            make.height.equalTo(50)
        }
        
        onboardingImageView.snp.makeConstraints { make in
            make.top.equalTo(textImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
    }
    
    func configureOnboardingImage(item: Int) {
        
        switch item {
        case 0: onboardingImageView.image = UIImage(named: "OnboardingImage1")
        case 1: onboardingImageView.image = UIImage(named: "OnboardingImage2")
        case 2: onboardingImageView.image = UIImage(named: "OnboardingImage3")
        default: onboardingImageView.image = UIImage(named: "OnboardingImage1")
        }
    }
    
    func configureOnboardingText(item: Int) {
        
        switch item {
        case 0: textImageView.image = UIImage(named: "OnboardingText1")
        case 1: textImageView.image = UIImage(named: "OnboardingText2")
        case 2: textImageView.image = UIImage(named: "OnboardingText3")
        default: textImageView.image = UIImage(named: "OnboardingText1")
        }
    }
    
}
