//
//  MyInfoViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import Toast
import MultiSlider

final class MyInfoViewController: BaseViewController {
    
    let mainView = MyInfoView()
    
    let viewModel = MyInfoViewModel()
    
    var alert = AlertView()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getUserInfo { message, code in }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        navigationItem.title = "정보 관리"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
    }
    
    @objc func saveButtonClicked() {
        
        let ageMin = Int(mainView.friendAgeView.ageSlider.value[0])
        let ageMax = Int(mainView.friendAgeView.ageSlider.value[1])

        viewModel.searchAge.accept([ageMin, ageMax]) //MultiSlider는 rx를 이용하지 못하기 때문에 직접 viewModel에 값을 저장해줘야한다.
        
        viewModel.updateUserInfo(completion: { message, code in
            switch code {
            case .success:
                self.view.makeToast("저장되었습니다.")
                self.navigationController?.popViewController(animated: true)
            case .firebaseTokenInvalid:
                self.view.makeToast("토큰이 만료되었습니다.")
            case .userUnexist:
                self.view.makeToast("가입 정보가 없습니다.")
            case .serverError:
                self.view.makeToast("서버 에러가 발생했습니다.")
            case .clientError:
                self.view.makeToast("사용자 에러가 발생했습니다.")
            default:
                self.view.makeToast("알 수 없는 오류가 발생했습니다.")
            }
        })
        
    }

    override func configureUI() {
        navigationItem.leftBarButtonItem = backBarButton
        
        backBarButton.target = self
        backBarButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
    }
    
    private func bind() {
        
        //MARK: 사용자 닉네임
        viewModel.nickName
            .asObservable()
            .bind(to: self.mainView.cardView.nickName.rx.text)
            .disposed(by: disposeBag)
        
        
        //MARK: 새싹 타이틀 컬렉션 뷰
        viewModel.title
            .bind(to: mainView.cardView.collectionView.rx
                    .items(cellIdentifier: "SeSACTitleCell")) { index, item, cell in
                guard let dataCell: SeSACTitleCell = cell as? SeSACTitleCell else { return }
                dataCell.sesacTitleButton.setTitle(item, for: .normal)
            }
            .disposed(by: disposeBag)
        

        //MARK: 새싹 리뷰
        viewModel.review
            .asObservable()
            .map { text in
                return text.joined(separator: ",")
            }
            .bind(to: self.mainView.cardView.sesacReviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        //MARK: 내 성별
        viewModel.gender
            .subscribe(onNext: { [self] _ in
                setGenderColor()
            })
            .disposed(by: disposeBag)
        
        mainView.userGenderView.maleButton.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.gender.accept(1)
            })
            .disposed(by: disposeBag)
        
        mainView.userGenderView.femaleButton.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.gender.accept(0)
            })
            .disposed(by: disposeBag)
        
        
        //MARK: 자주 하는 스터디
        mainView.favoriteStudyView.studyTextField.rx.text.orEmpty
            .subscribe(onNext: { [self] value in
                viewModel.study.accept(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.study
            .asObservable()
            .bind(to: self.mainView.favoriteStudyView.studyTextField.rx.text.orEmpty)
            .disposed(by: disposeBag)
       
        
        //MARK: 내 번호 검색 허용
        mainView.phoneSearchView.phoneNumberSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(mainView.phoneSearchView.phoneNumberSwitch.rx.value)
            .subscribe(onNext: { [self] value in
                if value {
                    viewModel.searchable.accept(1)
                } else {
                    viewModel.searchable.accept(0)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.searchable
            .subscribe(onNext: { [self] value in
                if value == 1 {
                    mainView.phoneSearchView.phoneNumberSwitch.isOn = true
                } else {
                    mainView.phoneSearchView.phoneNumberSwitch.isOn = false
                }
            })
            .disposed(by: disposeBag)

      
        //MARK: 회원탈퇴
        mainView.withdrawView.withdrawButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.showSeSACAlert()
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func setGenderColor() {
        
        if viewModel.gender.value == 1 {
            mainView.userGenderView.maleButton.buttonState = .fill
            mainView.userGenderView.femaleButton.buttonState = .inactive
        } else if viewModel.gender.value == 0 {
            mainView.userGenderView.maleButton.buttonState = .inactive
            mainView.userGenderView.femaleButton.buttonState = .fill
        }
    }
    
    private func showSeSACAlert() {
    
        alert.showAlert(title: "정말 탈퇴하시겠습니까?", SubTitle: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ", button: [.cancel, .done])
        
        alert.modalPresentationStyle = .overCurrentContext
        alert.handler = {
            self.viewModel.withdrawUser { message, code in
                switch code {
                case .success:
                    let vc = OnBoardingViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                default:
                    self.view.makeToast("회원탈퇴에 실패했어요.")
                }
            }
        }
        self.present(alert, animated: false)
    }
    
   
    
    

}




