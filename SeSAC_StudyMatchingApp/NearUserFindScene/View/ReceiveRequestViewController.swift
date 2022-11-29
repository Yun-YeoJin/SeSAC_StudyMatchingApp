//
//  ReceiveRequestViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/29.
//

import UIKit

final class ReceiveRequestViewController: BaseViewController {
    
    private let mainView = ReceiveRequestView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
