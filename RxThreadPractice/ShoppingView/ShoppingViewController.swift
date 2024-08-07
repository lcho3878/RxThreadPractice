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
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ShoppingViewModel()
    
    private let checkTapSubject = PublishSubject<Int>()
    private let starTapSubject = PublishSubject<Int>()
    private let contentSubject = PublishSubject<String>()
    
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
        view.register(TodoCell.self, forCellReuseIdentifier: TodoCell.id)
        return view
    }()
    
    private let collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.register(RecommendCell.self, forCellWithReuseIdentifier: RecommendCell.id)
        return view
    }()
    
    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 50)
        return layout
    }
    
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
        view.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(grayView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(grayView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func bind() {
        let input = ShoppingViewModel.Input(checkTap: checkTapSubject, starTap: starTapSubject, addTap: addButton.rx.tap, content: contentSubject)
        
        let output = viewModel.transfrom(input: input)
        
        output.list
            .bind(to: tableView.rx.items(cellIdentifier: TodoCell.id, cellType: TodoCell.self)) { [weak self] row, element, cell in
                cell.configureDate(element)
                guard let self = self else { return }
                cell.checkButton.rx.tap
                    .map { row }
                    .bind(to: self.checkTapSubject)
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .map { row }
                    .bind(to: self.starTapSubject)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        searchTextField.rx.text.orEmpty
            .bind(with: self, onNext: { owner, text in
                owner.contentSubject.onNext(text)
            })
            .disposed(by: disposeBag)
        
        output.recommendList
            .bind(to: collectionView.rx.items(cellIdentifier: RecommendCell.id, cellType: RecommendCell.self)) { row, element, cell in
                cell.configureDate(element)
            }
            .disposed(by: disposeBag)
        
        output.addTap
            .bind(with: self) { owner, _ in
                owner.contentSubject.onNext("")
                owner.searchTextField.rx.text.orEmpty.onNext("")
            }
            .disposed(by: disposeBag)
        

        
        
        tableView.rx.modelSelected(Todo.self)
            .map { $0.content }
            .bind(with: self) { owner, content in
                let detailVC = TodoDetailViewController()
                detailVC.content = content
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}


