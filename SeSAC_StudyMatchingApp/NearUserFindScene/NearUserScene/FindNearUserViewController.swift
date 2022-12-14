//
//  FindNearUserViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/29.
//

import UIKit

import Tabman
import Pageboy
import RxCocoa
import RxSwift

final class FindNearUserViewController: TabmanViewController {
    
    let firstVC = NearUserViewController()
    let secondVC = ReceiveRequestViewController()
    
    private var viewControllers: [UIViewController] = []
    private let titleList = ["주변 새싹", "받은 요청"]
    
    private var disposeBag = DisposeBag()
    
    private let viewModel = NearUserViewModel()
    
    private var timerDisposable: Disposable?
    
    private let backBarButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrow.left")
        $0.tintColor = .black
    }
    private let cancelSearchButton = UIBarButtonItem().then {
        $0.title = "찾기중단"
        $0.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers.append(contentsOf: [firstVC, secondVC])
        
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        bar.backgroundColor = .systemBackground
        bar.backgroundView.style = .blur(style: .regular)
        bar.buttons.customize { (button) in
            button.tintColor = .gray6
            button.selectedTintColor = .green
        }
        bar.indicator.weight = .light
        bar.indicator.tintColor = .green
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        
        addBar(bar, dataSource: self, at: .top)
        
        navigationItem.title = "새싹 찾기"
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    private func configureUI() {
        
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = cancelSearchButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationPopToViewController(HomeViewController())
            }.disposed(by: disposeBag)
        
        cancelSearchButton.target = self
        cancelSearchButton.rx.tap
            .bind { [weak self] in
                self?.requestDelete()
            }.disposed(by: disposeBag)
        
    }
    
    private func bindTimerMatch() {
        
        timerDisposable = Observable<Int>.timer(.milliseconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel.requestMYQueue()
            })
        
    }
    
    private func requestDelete() {
        
        viewModel.requestFindDelete {  [weak self] value in
            guard let self = self else { return }
            switch SearchQueueEnum(rawValue: value) {
            case .success:
                self.navigationPopToViewController(HomeViewController())
            case .bannedUser:
                self.view.makeToast("누군가와 스터디를 함께하기로 약속하셨어요!", duration: 1) { _ in
                    self.timerDisposable?.dispose()
                    self.bindTimerMatch()
                }
            case .firebaseTokenInvalid:
                self.viewModel.updateIdToken { [weak self] in
                    guard let self = self else { return }
                    self.requestDelete()
                }
            default:
                self.view.makeToast("에러가 발생했습니다.", position: .center)
            }
        }
        
    }
    
    private func bindViewModel() {
        
        viewModel.match
            .withUnretained(self)
            .bind (onNext: { vc, result in
                let viewController = ChattingViewController()
                if result.matched == 1 {
                    vc.view.makeToast("\(result.matchedNick ?? "")님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            viewController.viewModel.nickname = result.matchedNick ?? ""
                            viewController.viewModel.uid = result.matchedUid ?? ""
                            vc.transition(ChattingViewController(), transitionStyle: .push)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.matchError
            .withUnretained(self)
            .bind { vc, bool in
                if bool {
                    vc.view.makeToast("에러가 발생했습니다.", position: .center)
                }
            }.disposed(by: disposeBag)
    }
    
}

extension FindNearUserViewController: PageboyViewControllerDataSource, TMBarDataSource  {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = titleList[index]
        return TMBarItem(title: title)
    }
    
}

