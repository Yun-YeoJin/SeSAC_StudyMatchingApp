//
//  FriendsViewController.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/11/07.
//

import UIKit

final class FriendsViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "새싹친구"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}
