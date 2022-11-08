//
//  CustomButton.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

enum ButtonState: String {
    case inactive
    case fill
    case outline
    case cancel
    case disable
    case base
    case request
    case accept
}

final class CustomButton: UIButton {

    var buttonState: ButtonState = .inactive {
        didSet {
            configureUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureUI() {

        backgroundColor = .white
        tintColor = .black
        layer.cornerRadius = 5
        layer.borderColor = UIColor.white.cgColor

        switch buttonState {
        case .inactive:
            self.layer.borderColor = UIColor.gray4.cgColor
            setTitleColor(.black, for: .normal)
        case .fill:
            tintColor = .white
            setTitleColor(.white, for: .normal)
            backgroundColor = .green
        case .outline:
            self.layer.borderColor = UIColor.green.cgColor
            tintColor = .green
        case .cancel:
            backgroundColor = .gray2
        case .disable:
            tintColor = .gray3
            backgroundColor = .gray6
        case .base:
            setTitleColor(.black, for: .normal)
        case .request:
            backgroundColor = .error
            setTitleColor(.white, for: .normal)
        case .accept:
            backgroundColor = .success
            setTitleColor(.white, for: .normal)
        }
    }
}
