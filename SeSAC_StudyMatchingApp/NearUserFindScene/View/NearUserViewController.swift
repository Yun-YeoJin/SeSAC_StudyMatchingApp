//
//  NearUserViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/29.
//

import UIKit
import RxCocoa
import RxSwift

final class NearUserViewController: BaseViewController {
    
    private let mainView = NearUserView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
      
        
    }
}
