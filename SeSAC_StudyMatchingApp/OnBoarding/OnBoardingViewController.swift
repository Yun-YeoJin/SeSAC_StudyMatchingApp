//
//  OnBoardingViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

final class OnBoardingViewController: BaseViewController {
    
    let mainView = OnBoardingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(OnBoardingCollectionViewCell.self, forCellWithReuseIdentifier: OnBoardingCollectionViewCell.reuseIdentifier)
        mainView.collectionView.isPagingEnabled = true
        
        view.backgroundColor = .systemBackground
        
        if let layout = mainView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = . zero
            layout.scrollDirection = .horizontal
            
            //pageControl 동그라미 갯수 몇 개 만들건지 설정
            mainView.pageControl.numberOfPages = 3
        }
        
        mainView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    
        
    }
    
    @objc func startButtonClicked() {
        
        self.dismiss(animated: true)
        UserDefaults.standard.set(true, forKey: "SecondRun")
        
    }
    
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.reuseIdentifier, for: indexPath) as? OnBoardingCollectionViewCell else { return UICollectionViewCell() }

        let item = indexPath.item

        cell.configureOnboardingText(item: item)
        cell.configureOnboardingImage(item: item)

        return cell
    }
    
    
    
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
}


extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.mainView.collectionView.bounds.width)
        mainView.pageControl.currentPage = index
    }
}
