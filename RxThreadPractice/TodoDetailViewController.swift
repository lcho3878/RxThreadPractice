//
//  TodoDetailViewController.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/4/24.
//

import UIKit

final class TodoDetailViewController: UIViewController {
    
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let content {
            title = content
        }
    }
    
}
