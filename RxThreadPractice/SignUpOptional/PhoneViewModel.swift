//
//  PhoneViewModel.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let phoneNumber: ControlProperty<String>
    }
    
    struct Output {
        let validation: Observable<Validation>
    }
    
    func transform(input: Input) -> Output {
       let validation = input.phoneNumber
            .map {
                guard Int($0) != nil else { return Validation.fail(PhoneValidation.notNumberError) }
                guard $0.count >= 10 else { return Validation.fail(PhoneValidation.lengthError) }
                return Validation.success(PhoneValidation.success)
            }
//            .map{
//                guard Int($0) != nil else { return .fail(PhoneValidation.notNumberError)}
//                guard $0.count >= 10 else { return .fail(PhoneValidation.lengthError) }
//                return .success(PhoneValidation.success)
//            }
        return Output(validation: validation)
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
