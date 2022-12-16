//
//  PopupViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/08.
//

import UIKit

import RxSwift
import SnapKit
import FirebaseAuth

final class PopupViewController: BaseViewController {
    
    let mainView = PopupAlertView()
    let disposeBag = DisposeBag()
    
    var request: Bool = true
    var uid: String?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        popupCustom()
        bindTo()
    }
    
    override func setConstraints() {
        mainView.alertView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        
        mainView.cancelButton.snp.remakeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(mainView.snp.centerX).offset(-4)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
        
        mainView.okButton.snp.remakeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(mainView.snp.centerX).offset(4)
            make.height.equalToSuperview().multipliedBy(0.26)
        }
    }
    
    private func popupCustom() {
        if request {
            mainView.titleText(
                title: "스터디를 요청할게요!",
                subTitle:
                        """
                        상대방이 요청을 수락하면
                        채팅창에서 대화를 나눌 수 있어요
                        """
            )
        } else {
            mainView.titleText(title: "스터디를 수락할까요?", subTitle: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요")
        }
        
        mainView.subTitleLabel.textColor = .gray7
        mainView.cancelButton.backgroundColor = .gray2
        mainView.cancelButton.layer.borderWidth = 0
        
    }
    
    private func bindTo() {
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: false)
            }.disposed(by: disposeBag)
        
        mainView.okButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vc, _ in
                if vc.request {
                    vc.requestPost()
                } else {
                    vc.acceptPost()
                }
            }.disposed(by: disposeBag)
    }
    
    func dismissToast(message: String) {
        self.dismiss(animated: false) {
            guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
            vc.view.makeToast(message)
        }
    }
}

extension PopupViewController {
    private func requestPost() {
        guard let uid = uid else { return }
        SeSACAPIService.shared.requestStatusSeSACAPI(router: QueueRouter.request(query: UserDefaultsRepository.fetchUserIDToken(), uid: uid)) { [weak self] value in
            guard let self = self else { return }
            
            switch StudyAcceptEnum(rawValue: value) {
            case .success:
                self.dismissToast(message: "스터디 요청을 보냈습니다")
            case .alreadyMatched:
                self.acceptPost()
            case .cancelSearch:
                self.dismissToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            case .firebaseTokenInvalid:
                self.updateIdToken { [weak self] in
                    guard let self = self else {return}
                    self.requestPost()
                }
            default:
                self.view.makeToast("에러가 발생했습니다")
            }
        }
    }
}

extension PopupViewController {
    private func acceptPost() {
        guard let uid = uid else {
            view.makeToast("에러가 발생했습니다.")
            return}
        SeSACAPIService.shared.requestStatusSeSACAPI(router: QueueRouter.accept(query: UserDefaultsRepository.fetchUserIDToken(), uid: uid)) { [weak self] value in
            guard let self = self else { return }
            switch StudyAcceptEnum(rawValue: value) {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("dispose"), object: self)
                self.dismiss(animated: false) { [weak self] in
                    guard let self = self else { return }
                    if self.request {
                        guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        vc.view.makeToast("상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다", duration: 1) { _ in
                            self.requestMYQueue { result in
                                let chatting = ChattingViewController()
                                chatting.viewModel.uid = result.matchedUid ?? ""
                                chatting.viewModel.nickname = result.matchedNick ?? ""
                                vc.transition(chatting, transitionStyle: .push)
                            }
                        }
                    } else {
                        guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        self.requestMYQueue { result in
                            let chatting = ChattingViewController()
                            chatting.viewModel.uid = result.matchedUid ?? ""
                            chatting.viewModel.nickname = result.matchedNick ?? ""
                            vc.transition(chatting, transitionStyle: .push)
                        }
                    }
                }
                // 사용자 현재 상태를 매칭 상태로 변경하고, 팝업 화면을 dismiss 한 뒤, 채팅 화면(1_5_chatting)으로 화면을 전환합니다.
            case .alreadyMatched:
                self.dismissToast(message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
            case .cancelSearch:
                self.dismissToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            case .alreadyAccepted:
                self.dismissToast(message: "앗! 누군가가 나의 스터디를 수락하였어요!")
            case .firebaseTokenInvalid:
                self.updateIdToken { [weak self] in
                    guard let self = self else {return}
                    self.acceptPost()
                }
            default:
                self.view.makeToast("에러가 발생했습니다")
            }
        }
    }
    
    func requestMYQueue(completion: @escaping (NearUserMatch) -> Void) {
        SeSACAPIService.shared.requestSeSACAPI(type: NearUserMatch.self, router: QueueRouter.myQueueState(query: UserDefaultsRepository.fetchUserIDToken())) { result in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(_):
                print("Ssss")
                }
            }
        }
}

