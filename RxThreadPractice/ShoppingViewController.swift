//
//  ShoppingViewController.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Todo {
    let content: String
    var isComleted = false
    var isStared = false
}

struct TodoDummy {
    static var dummy = [
        Todo(content: "그립톡 구매하기"),
        Todo(content: "사이다 구매"),
        Todo(content: "아이패드 케이스 최저가 알아보기"),
        Todo(content: "양말"),
    ]
}

final class ShoppingViewController: UIViewController {
    
    private let grayView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let searchTextField = {
        let view = UITextField()
        view.placeholder = "무엇을 구매하실 건가요?"
        return view
    }()
    
    private let addButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let tableView = {
        let view = UITableView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(grayView)
        grayView.addSubview(addButton)
        grayView.addSubview(searchTextField)
        view.addSubview(tableView)
        
        grayView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(addButton.snp.leading).offset(8)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(grayView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(grayView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {

    }
    
}
