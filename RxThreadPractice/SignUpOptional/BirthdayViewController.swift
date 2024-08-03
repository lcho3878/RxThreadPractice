//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()

    let infoLabel = ValidationLabel(validation: nil)
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let year = PublishSubject<Int>()
    let month = PublishSubject<Int>()
    let day = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func bind() {
        year.bind(with: self) { owner, year in
            owner.yearLabel.rx.text.onNext("\(year)년")
        }
        .disposed(by: disposeBag)
        
        month.bind(with: self) { owner, month in
            owner.monthLabel.rx.text.onNext("\(month)월")
        }
        .disposed(by: disposeBag)
        
        day.bind(with: self) { owner, day in
            owner.dayLabel.rx.text.onNext("\(day)일")
        }
        .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                guard let year = components.year,
                let month = components.month,
                let day = components.day else { return }
                owner.year.onNext(year)
                owner.month.onNext(month)
                owner.day.onNext(day)
            }
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .map{
                let target = Calendar.current.date(byAdding: .year, value: -17, to: Date())!
                guard target > $0 else { return .fail(BirthdayValidation.fail)}
                return .success(BirthdayValidation.success)
            }
            .bind(with: self) { owner, value in
                owner.infoLabel.rx.validation.onNext(value)
                
            }
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .map {
                let target = Calendar.current.date(byAdding: .year, value: -17, to: Date())!
                return target > $0
            }
            .bind(with: self) { owner, value in
                owner.nextButton.rx.isEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    enum BirthdayValidation: ValidationResult {
        case success
        case fail
        
        var message: String {
            switch self {
            case .success:
                return "가입 가능한 나이입니다."
            case .fail:
                return "만 17세 이상만 가입 가능합니다."
            }
        }
    }
}
