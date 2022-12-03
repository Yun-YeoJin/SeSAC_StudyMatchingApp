//
//  KeyWordViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/17.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import RxKeyboard

final class KeyWordViewController: BaseViewController {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let mainView = KeyWordView()
    let viewModel = KeyWordViewModel()
    
    var disposeBag = DisposeBag()
    
    let maxLength = 8
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("myIdToken : \(UserDefaultsRepository.fetchUserIDToken())")
        
        searchNearSeSAC()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        bindSearchBar()
        bindRxKeyboard()
        setGesture()
        bindButton()
        
    }

    override func configureUI() {
       
        self.navigationItem.titleView = searchBar
        self.navigationItem.leftBarButtonItem = mainView.backBarButton
        mainView.backBarButton.target = self
        mainView.backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
    func searchNearSeSAC() {
        
        print("Lat은 몇이게요 ?? \(viewModel.lat.value)")
        print("Long은 몇이게요 ?? \(viewModel.long.value)")
        viewModel.searchNearSeSAC { [self] message, code in
            switch code {
            case .userUnexist:
                self.view.makeToast("사용자가 없습니다.")
            default:
                self.view.makeToast("\(code)")
            }
        }
    }
    
    private func bindButton() {
        mainView.findSeSACButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel.searchQueue { message, code in
                    switch code {
                    case .success:
                        vc.transition(FindNearUserViewController(), transitionStyle: .push)
                    default:
                        vc.view.makeToast("\(code.rawValue) 오류 발생", position: .center)
                        print(vc.viewModel.long.value)
                        print(vc.viewModel.lat.value)
                        print(vc.viewModel.studyListUser)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        
        // 텍스트 변경시
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [self] text in
                if text.count > maxLength { // 최대 8자
                    self.view.makeToast("취미는 최대 8자만 가능해요.")
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    searchBar.text = String(newString)
                }
            }).disposed(by: disposeBag)
        
        // search 버튼 눌렸을 경우
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                let StudyList = vc.viewModel.getStudyData(self.searchBar.text!)
                switch StudyList {
                case .full:
                    vc.view.makeToast("8개까지 등록 가능합니다.")
                    return
                case .empty:
                    return
                case .success:
                    vc.mainView.collectionView.reloadData()
                case .invalid:
                    vc.view.makeToast("유효하지 않은 값입니다.")
                    return
                case .contained:
                    vc.view.makeToast("중복된 값입니다.")
                    return
                }
                vc.searchBar.text = ""
            }).disposed(by: disposeBag)
    }
    
    private func setGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.mainView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.mainView.addGestureRecognizer(swipeUp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismisskeyboard() {
        searchBar.endEditing(true)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up:
                searchBar.becomeFirstResponder()
            case UISwipeGestureRecognizer.Direction.down:
                searchBar.endEditing(true)
            default:
                break
            }
        }
    }
    
    private func bindRxKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive { [self] height in
                if height == 0 {
                    mainView.findSeSACButton.layer.cornerRadius = 8
                    mainView.findSeSACButton.snp.updateConstraints { make in
                        make.leading.trailing.equalToSuperview().inset(10)
                        make.height.equalTo(48)
                        make.bottom.equalTo(mainView.safeAreaLayoutGuide)
                    }
                } else {
                    mainView.findSeSACButton.layer.cornerRadius = 0
                    mainView.findSeSACButton.snp.updateConstraints { make in
                        make.bottom.equalTo(mainView.safeAreaLayoutGuide).inset(height - mainView.safeAreaInsets.bottom)
                        make.leading.trailing.equalToSuperview()
                    }
                }
                // 애니메이션
                view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
    
}

extension KeyWordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.fromRecommend.value.count + viewModel.studyListData.count
        case 1:
            return viewModel.studyListUser.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyWordCollectionViewCell.reuseIdentifier, for: indexPath) as? KeyWordCollectionViewCell else { return UICollectionViewCell() }
        
        let StudyListDataIndex = viewModel.fromRecommend.value.count
        let recommendIndex = self.viewModel.fromRecommend.value.count
        
        switch indexPath.section {
        case 0:
            if indexPath.row >= viewModel.fromRecommend.value.count {
                cell.shellView.layer.borderColor = UIColor.gray6.cgColor
                cell.label.textColor = .label
                cell.label.text = viewModel.studyListData[StudyListDataIndex]
                cell.button.isHidden = true
                cell.cellTapActionHandler = {
                    if self.viewModel.studyListUser.count >= 8 {
                        self.view.makeToast("8개까지 등록 가능합니다.")
                        return
                    }
                    if !self.viewModel.studyListUser.contains(self.viewModel.studyListData[indexPath.row - self.viewModel.fromRecommend.value.count]) {
                        self.viewModel.studyListUser.append(self.viewModel.studyListData[indexPath.row - recommendIndex])
                        self.mainView.collectionView.reloadData()
                    }
                    
                }
            } else {
                cell.shellView.layer.borderColor = UIColor.red.cgColor
                cell.label.textColor = .red
                cell.label.text = viewModel.fromRecommend.value[indexPath.row]
                cell.button.isHidden = true
                cell.cellTapActionHandler = {
                    if self.viewModel.studyListUser.count >= 8 {
                        self.view.makeToast("8개까지 등록 가능합니다.")
                        return
                    }
                    if !self.viewModel.studyListUser.contains(self.viewModel.fromRecommend.value[indexPath.row]) {
                        self.viewModel.studyListUser.append(self.viewModel.fromRecommend.value[indexPath.row])
                        self.mainView.collectionView.reloadData()
                    }
                }
            }
        case 1:
            cell.shellView.layer.borderColor = UIColor.green.cgColor
            cell.label.textColor = .green
            cell.label.text = viewModel.studyListUser[indexPath.row]
            cell.button.isHidden = false
            cell.cellTapActionHandler = {
                // 셀 삭제
                self.viewModel.studyListUser.remove(at: indexPath.row)
                self.mainView.collectionView.reloadData()
            }
        default:
            print(#function, "default")
        }

        
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
       return CGSize(width: size.width + 10, height: size.height + 14)
   }
}
