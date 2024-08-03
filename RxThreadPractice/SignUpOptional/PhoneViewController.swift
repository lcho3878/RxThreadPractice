//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    private let disposeBag = DisposeBag()
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
//    let validationLabel = ValidationLabel(valid: "사용 가능한 휴대폰 번호입니다.", nonValid: "10자 이상이여야 합니다.")
    let validationLabel = ValidationLabel(validation: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        phoneTextField.text = "010"
        bind()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(validationLabel)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        validationLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(phoneTextField.snp.bottom)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }

    private func bind() {
        phoneTextField.rx.text.orEmpty
            .map{
                guard Int($0) != nil else { return .fail(PhoneValidation.notNumberError)}
                guard $0.count >= 10 else { return .fail(PhoneValidation.lengthError) }
                return .success(PhoneValidation.success)
            }
            .bind(with: self) { owner, value in
                owner.validationLabel.rx.validation.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    enum PhoneValidation: ValidationResult {
        case success
        case lengthError
        case notNumberError
        
        var message: String {
            switch self {
            case .success:
                return "사용 가능한 휴대폰 번호"
            case .lengthError:
                return "10자 이상만 가능"
            case .notNumberError:
                return "숫자만 입력 가능"
            }
        }
    }
}
