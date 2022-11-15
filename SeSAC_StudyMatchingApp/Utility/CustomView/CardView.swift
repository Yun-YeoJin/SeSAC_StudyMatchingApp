//
//  CardView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CardView: BaseView {
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_background_1")
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    let sesacImage = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_1")
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    let nickNameView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    let nickName = UILabel().then {
        $0.text = "윤새싹"
        $0.font = .title1_M16
    }
    
    let nickNameDownButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .gray7
        $0.backgroundColor = .clear
    }
    
    let sesacTitleView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    let sesacTitle = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.font = .title6_R12
    }
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.isScrollEnabled = false
        view.register(SeSACTitleCell.self, forCellWithReuseIdentifier: SeSACTitleCell.reuseIdentifier)
        return view
    }()
    
    let sesacReviewView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    let sesacReviewLabel = UILabel().then {
        $0.text = "새싹 리뷰"
        $0.font = .title6_R12
    }
    
    let sesacReViewTextView = UITextView().then {
        $0.text = "첫 리뷰를 기다리는 중이에요!"
        $0.clipsToBounds = true
        $0.isEditable = false
        $0.textColor = .gray6
        $0.font = .body3_R14
    }
    
    let reviewButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        $0.tintColor = .gray7
        $0.backgroundColor = .clear
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.clipsToBounds = true
    }
    
    var cardFlag = true
    
    var buttonTapActionHandler: (() -> Void)?
    
    var reviewButtonTapActionHandler: (() -> Void)?
    
    var disposeBag = DisposeBag()
    
    @objc func nickNameButtonTapped(_ sender: UIButton) {
        buttonTapActionHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bindButton()
        
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        
        hideView(cardFlag)
        
        nickNameDownButton.addTarget(self, action: #selector(nickNameButtonTapped(_:)), for: .touchUpInside)
    }
    
    func bindButton() {
        
        nickNameDownButton.rx.tap
            .bind { [self] _ in
                cardFlag.toggle()
                hideView(cardFlag)
            }
            .disposed(by: disposeBag)
        
        reviewButton.rx.tap
            .bind { [self] _ in
                reviewButtonTapActionHandler?()
            }
            .disposed(by: disposeBag)
        
    }
    
    func hideView(_ value: Bool) {
        
        [sesacTitleView, sesacReviewView].forEach {
            $0.isHidden = value
        }
        
        if value {
            nickNameDownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            nickNameDownButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        
    }
    
    override func configureUI() {
        
        [imageView, sesacImage, stackView].forEach {
            self.addSubview($0)
        }
        
        [nickNameView, sesacTitleView, sesacReviewView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [nickName, nickNameDownButton].forEach {
            nickNameView.addSubview($0)
        }
        
        [sesacTitle, collectionView].forEach {
            sesacTitleView.addSubview($0)
        }
        
        [sesacReviewLabel, sesacReViewTextView, reviewButton].forEach {
            sesacReviewView.addSubview($0)
        }
        
        
    }
    
    override func setConstraints() {
        
        //MARK: SeSAC Image
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(194)
        }
        
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(184)
            make.bottom.equalTo(imageView.snp.bottom).offset(16)
        }
        
        //MARK: StackView = NickName + SeSAC Title + SeSAC Review
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //MARK: NickName
        nickNameView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        nickName.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(nickNameDownButton.snp.leading).offset(-16)
            make.height.equalTo(26)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        nickNameDownButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(nickName.snp.trailing).offset(16)
            make.width.height.equalTo(24)
        }
        
        //MARK: SeSAC Title
        sesacTitleView.snp.makeConstraints { make in
            make.top.equalTo(nickNameView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        sesacTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalToSuperview()
        }
        
        //MARK: SeSAC Review
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        sesacReViewTextView.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-30)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(12)
            make.width.equalTo(6)
        }
    }
}


extension CardView: UICollectionViewDelegateFlowLayout {
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))//Label 크기에 따른 사이즈 자동 조절
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2) //2줄로 표현하겠다.
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}
