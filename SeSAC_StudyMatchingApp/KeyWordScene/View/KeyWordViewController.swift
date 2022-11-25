//
//  KeyWordViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift

final class KeyWordViewController: BaseViewController {
    
    let mainView = KeyWordView()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
    }
    
    override func configureUI() {
       
        self.navigationItem.titleView = mainView.searchBar
        self.navigationItem.leftBarButtonItem = mainView.backBarButton
        mainView.backBarButton.target = self
        mainView.backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
}

extension KeyWordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyWordCollectionViewCell.reuseIdentifier, for: indexPath) as? KeyWordCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "KeyWordHeaderView", for: indexPath) as? KeyWordHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            headerView.HeaderLabel.text = "지금 주변에는"
        } else if indexPath.section == 1 {
            headerView.HeaderLabel.text = "내가 하고 싶은"
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 40)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 40)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 40)
        default:
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
    
    
}

extension KeyWordViewController: UICollectionViewDelegateFlowLayout {
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       let label = UILabel().then {
           $0.font = .title1_M16
           $0.text = "dummy"
           $0.sizeToFit()
       }
       let size = label.frame.size
       return CGSize(width: size.width + 34, height: size.height + 14)
   }
}


