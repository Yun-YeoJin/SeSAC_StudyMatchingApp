//
//  BaseViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

import Then
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    
    let backBarButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrow.left")
        $0.tintColor = .black
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureUI()
        setConstraints()
        hideKeyboardWhenTappedAround()
        
    }
    
    func configureUI() {
        
       
        
    }
    
    func setConstraints() {
        
    }
    
}
