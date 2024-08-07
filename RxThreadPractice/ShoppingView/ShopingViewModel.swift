//
//  ShopingViewModel.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/7/24.
//
import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    let disposeBag = DisposeBag()
    
    var data = TodoDummy.dummy
    
    var recommendList = ["아이패드", "에어팟", "맥북", "맥미니", "맥맥맥", "맥123"]

//    lazy var list = BehaviorSubject(value: data)
    
    struct Input {
        let checkTap: PublishSubject<Int>
        let starTap: PublishSubject<Int>
        let addTap: ControlEvent<Void>
        let content: PublishSubject<String>
    }
    
    struct Output {
//         let checkTap: BehaviorSubject<[Todo]>
        let addTap: ControlEvent<Void>
        let list: BehaviorSubject<[Todo]>
        let recommendList: Observable<[String]>
    }
    
    func transfrom(input: Input) -> Output {
        let list = BehaviorSubject<[Todo]>(value: data)
        input.checkTap.bind(with: self, onNext: { owner, row in
            owner.data[row].isComleted.toggle()
            list.onNext(owner.data)
        })
            .disposed(by: disposeBag)
        
        input.starTap.bind(with: self, onNext: { owner, row in
            owner.data[row].isStared.toggle()
            list.onNext(owner.data)
        })
            .disposed(by: disposeBag)
        
        input.addTap
            .withLatestFrom(input.content)
             { _, text in
                print("latest: \(text)")
                return text }
            .bind(with: self) { owner, text in
                print("text: \(text)")
                guard !text.isEmpty else { return }
                owner.data.append(Todo(content: text))
                list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(addTap: input.addTap, list: list, recommendList: Observable.just(recommendList))
    }
}
