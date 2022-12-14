//
//  NearUserViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/29.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources

final class NearUserViewController: BaseViewController, UITableViewDelegate {
    
    private let mainView = NearUserView()
    
    let viewModel = NearUserViewModel()
    
    private var disposeBag = DisposeBag()
    
    private let alert = AlertView()
    
    private var heightChange: [Bool] = []
    private var info: [FromQueueDB] = []
    
    private var dataSources: RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewModel.searchSesac.accept(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    private func setTableView(sesacInfo: Queue) {
        
        dataSources = RxTableViewSectionedReloadDataSource<SeSACFindSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NearUserTableViewCell.reuseIdentifier, for: indexPath) as? NearUserTableViewCell else {return UITableViewCell()}
            cell.acceptButton.setTitle("수락하기", for: .normal)
            cell.acceptButton.backgroundColor = .blue
            cell.cardView.sesacBackgroundImageView.image = UIImage.sesacBackgroundImage(num: item.backgroundImage)
            cell.cardView.sesacImage.image = UIImage.sesacImage(num: item.image)
            
            cell.acceptButton.tag = indexPath.section
            cell.acceptButton.addTarget(self, action: #selector(self.requestButtonTapped), for: .touchUpInside)
            return cell
            
        })
        var sections: [SeSACFindSectionModel] = []
        
        for i in sesacInfo.fromQueueDBRequested {
            sections.append(SeSACFindSectionModel(items: [NearUserFind(uid: i.uid, backgroundImage: i.background, image: i.sesac), NearUserFind(nickname: i.nick, sesacTitle: i.reputation, comment: i.reviews, studyList: i.studylist)]))
        }
        
        let data = Observable<[SeSACFindSectionModel]>.just(sections)
        
        data.bind(to: mainView.tableView.rx.items(dataSource: dataSources!))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        sections.isEmpty ? noSeSACHidden(bool: false) :  noSeSACHidden(bool: true)
        
        heightChange = Array(repeating: false, count: sections.count)
    }
    
    private func noSeSACHidden(bool: Bool) {
        mainView.sesacImageView.isHidden = bool
        mainView.titleLabel.isHidden = bool
        mainView.subTitleLabel.isHidden = bool
        mainView.changeButton.isHidden = bool
        mainView.reloadButton.isHidden = bool
        mainView.titleLabel.text = "아쉽게도 주변에 새싹이 없어요 ㅠㅠ"
    }
    
}

extension NearUserViewController {
    
    private func bind() {
        let input = NearUserViewModel.Input(
            reload: mainView.reloadButton.rx.tap,
            change: mainView.changeButton.rx.tap,
            refresh:  mainView.refreshControl.rx.controlEvent(.valueChanged),
            tableItem: mainView.tableView.rx.itemSelected
        )
        
        let output = viewModel.transform(input: input)
        
        output.sesacInfo
            .withUnretained(self)
            .subscribe (onNext: { vc, sesacInfo in
                vc.info = sesacInfo.fromQueueDBRequested
                vc.setTableView(sesacInfo: sesacInfo)
            }).disposed(by: disposeBag)
        
        output.networkFailed
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] error in
                guard let self = self else { return }
                if error == true {
                    self.view.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)
        
        output.tableItem
            .withUnretained(self)
            .subscribe { vc, index in
                guard let cell =  vc.mainView.tableView.cellForRow(at: index) as? NearUserTableViewCell else { return }
                if index.section == cell.tag {
                    if index.row == 1 {
                        vc.heightChange[cell.tag].toggle()
                        vc.mainView.tableView.reloadRows(at: [IndexPath(row: index.row, section: index.section)], with: .fade)
                    }
                }
            }.disposed(by: disposeBag)
        
        bindEmptyScreen(output: output)
        bindSearchRequest(output: output)
    }
    
    private func bindSearchRequest(output: NearUserViewModel.Output) {
        
        output.searchSesac
            .asDriver(onErrorJustReturn: false)
            .drive (onNext: { [weak self] bool in
                guard let self = self else { return }
                if bool {
                    self.mainView.tableView.dataSource = nil
                    self.mainView.tableView.delegate = nil
                    self.viewModel.requsetSearch(output: output)
                }
            }).disposed(by: disposeBag)
        
        output.refresh
            .withUnretained(self)
            .bind {vc, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    vc.mainView.tableView.dataSource = nil
                    vc.mainView.tableView.delegate = nil
                    vc.viewModel.requsetSearch(output: output)
                    vc.mainView.refreshControl.endRefreshing()
                }
            }.disposed(by: disposeBag)
        
    }
    
    private func bindEmptyScreen(output: NearUserViewModel.Output) {
        
        output.reload
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.tableView.dataSource = nil
                vc.mainView.tableView.delegate = nil
                vc.viewModel.requsetSearch(output: output)
            }.disposed(by: disposeBag)
        
        output.change
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.requestDelete(KeyWordViewController())
            }.disposed(by: disposeBag)
        
    }
    
    private func requestDelete<T: UIViewController>(_ vc: T) {
        viewModel.requestFindDelete {  [weak self] value in
            guard let self = self else {return}
            switch StudyAcceptEnum(rawValue: value) {
            case .success:
                self.navigationPopToViewController(T())
            case .alreadyMatched:
                self.view.makeToast("이미 매칭된 상태입니다.", position: .center)
            case .firebaseTokenInvalid:
                self.updateIdToken(T())
            default:
                self.view.makeToast("에러가 발생했습니다.", position: .center)
            }
        }
    }
    
    private func updateIdToken<T: UIViewController>(_ vc: T) {
        self.updateIdToken { [weak self] in
            guard let self = self else {return}
            self.requestDelete(T())
        }
    }
}

//MARK: Objc func Method
extension NearUserViewController {
    
    @objc func reviewButtonTapped(_ sender: UIButton) {
        let vc = ReviewViewController()
        vc.reviewList = info[sender.tag].reviews
        transition(vc, transitionStyle: .push)
    }
    
    @objc func requestButtonTapped(_ sender: UIButton) {
        let vc = PopupViewController()
        vc.uid = info[sender.tag].uid
        vc.request = false
        transition(vc, transitionStyle: .presentFullNavigation)
    }
    
}
