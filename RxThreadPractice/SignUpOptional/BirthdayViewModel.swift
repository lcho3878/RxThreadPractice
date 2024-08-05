//
//  BirthdayViewModel.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let date: ControlProperty<Date>
    }
    
    struct Output {
        let year: PublishSubject<String>
        let month: PublishSubject<String>
        let day: PublishSubject<String>
        let validation: PublishSubject<Validation>
        let isValid: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let year = PublishSubject<String>()
        let month = PublishSubject<String>()
        let day = PublishSubject<String>()
        let isValid = PublishSubject<Bool>()
        let validation = PublishSubject<Validation>()
        let date = input.date.share()
        date
            .bind(with: self) { owner, date in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                guard let yearComponent = components.year,
                      let monthComponent = components.month,
                      let dayComponent = components.day else { return }
                year.onNext("\(yearComponent)년")
                month.onNext("\(monthComponent)월")
                day.onNext("\(dayComponent)일")
            }
            .disposed(by: disposeBag)
        
        date
            .map{
                let target = Calendar.current.date(byAdding: .year, value: -17, to: Date())!
                guard target > $0 else { return .fail(BirthdayValidation.fail)}
                return .success(BirthdayValidation.success)
            }
            .bind { result in
                validation.onNext(result)
            }
            .disposed(by: disposeBag)
      
        
        date
            .map {
                let target = Calendar.current.date(byAdding: .year, value: -17, to: Date())!
                return target > $0
            }
            .bind { value in
                isValid.onNext(value)
            }
            .disposed(by: disposeBag)

        return Output(year: year, month: month, day: day, validation: validation, isValid: isValid)
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
