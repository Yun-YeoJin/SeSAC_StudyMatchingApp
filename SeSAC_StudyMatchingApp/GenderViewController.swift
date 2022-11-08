//
//  GenderViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class GenderViewController: BaseViewController {
    
    let mainView = GenderView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
