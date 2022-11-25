//
//  KeyWordView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import UIKit

import Then
import SnapKit

final class KeyWordView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
    }
    
    let backBarButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrow.left")
        $0.tintColor = .black
    }
    
    let collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = false
        view.register(KeyWordCollectionViewCell.self, forCellWithReuseIdentifier: KeyWordCollectionViewCell.reuseIdentifier)
        view.register(KeyWordHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "KeyWordHeaderView")
        view.contentInset = UIEdgeInsets(top: .zero, left: 16, bottom: 16, right: 16)
        return view
    }()
    
    let findSeSACButton = CustomButton().then {
        $0.setTitle("새싹 찾기", for: .normal)
        $0.buttonState = .fill
        $0.titleLabel?.font = .title4_R14
    }
    
    private var keyHeight: CGFloat? // 키보드 높이 저장
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
    }
    
    override func configureUI() {
        
        [collectionView, findSeSACButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        findSeSACButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
    }
    
    private class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            
            let attributes = super.layoutAttributesForElements(in: rect)
            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            
            attributes?.forEach { layoutAttribute in
                if layoutAttribute.representedElementCategory == .cell {
                    
                    if layoutAttribute.frame.origin.y >= maxY {
                        leftMargin = sectionInset.left
                    }
                    
                    layoutAttribute.frame.origin.x = leftMargin
                    leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                    maxY = max(layoutAttribute.frame.maxY, maxY)
                    
                }
            }
            return attributes
        }
    }
}
