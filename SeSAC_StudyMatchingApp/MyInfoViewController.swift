//
//  MyInfoViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift


final class MyInfoViewController: BaseViewController {
    
    let mainView = MyInfoView()
    
    let viewModel = MyInfoViewModel()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "정보 관리"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        bindcollectionView()
    }
    
    @objc func saveButtonClicked() {
        
    }
    
    override func configureUI() {
        navigationItem.leftBarButtonItem = backBarButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    func bindcollectionView() {
        viewModel.title
            .bind(to: mainView.cardView.collectionView.rx
                    .items(cellIdentifier: "SeSACTitleCell")) { index, item, cell in
                guard let dataCell: SeSACTitleCell = cell as? SeSACTitleCell else { return }
                
                dataCell.sesacTitleButton.setTitle(item, for: .normal)
            }
            .disposed(by: disposeBag)
    }

    
}




