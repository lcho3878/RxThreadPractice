//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    private let disposeBag = DisposeBag()
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let validLabel = {
        let view = UILabel()
        view.text = "비밀번호는 8자 이상 입력해주세요"
        view.textColor = .systemRed
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(validLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        validLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.bottom.equalTo(nextButton.snp.top)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .bind(with: self) { owner, value in
                owner.validLabel.rx.isHidden.onNext(value)
                owner.nextButton.rx.isEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
