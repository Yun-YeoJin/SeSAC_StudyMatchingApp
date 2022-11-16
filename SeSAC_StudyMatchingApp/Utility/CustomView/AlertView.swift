//
//  AlertView.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/16.
//

import UIKit

import SnapKit
import Then

enum Button {
    case done
    case cancel
}

final class AlertView: BaseViewController {
    
    let mainView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 16
    }
    let titleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .body1_M16
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    let subTitleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .title4_R14
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let doneButton = CustomButton().then {
        $0.setTitle("확인", for: .normal)
        $0.buttonState = .fill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    let cancelButton = CustomButton().then {
        $0.setTitle("취소", for: .normal)
        $0.buttonState = .cancel
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    var handler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        doneButton.addTarget(self, action: #selector(doneButtonPressedClicked), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    @objc func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func doneButtonPressedClicked(_ sender: UIButton) {
        handler?()
    }
    
    func showAlert(title: String, SubTitle: String, button: [Button]) {
        
        titleLabel.text = title
        subTitleLabel.text = SubTitle
        
        for button in button {
            
            switch button {
            case .done:
                stackView.addArrangedSubview(doneButton)
                doneButton.snp.makeConstraints { make in
                    make.height.equalTo(48)
                }
            case .cancel:
                stackView.addArrangedSubview(cancelButton)
                cancelButton.snp.makeConstraints { make in
                    make.height.equalTo(48)
                }
            }
        }
    }
    override func configureUI() {
        
        view.addSubview(mainView)
        
        [titleLabel, subTitleLabel, stackView].forEach {
            mainView.addSubview($0)
        }
        
        
    }
    
    
    override func setConstraints() {
        
        mainView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.greaterThanOrEqualTo(156)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        }
        
    }
}

