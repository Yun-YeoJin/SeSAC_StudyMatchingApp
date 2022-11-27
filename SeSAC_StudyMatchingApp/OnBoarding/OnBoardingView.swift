//
//  OnBoardingView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class OnBoardingView: BaseView {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .green
    }
    
    let startButton = CustomButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.buttonState = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
        
    }
    
    override func configureUI() {
        
        [collectionView, pageControl, startButton].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(116)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).multipliedBy(0.95)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(48)
        }
    }
    
}
