//
//  ValidationLabel.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/2/24.
//

import UIKit

class ValidationLabel: UILabel {
    
    var isValid: Bool {
        if case .success = validation {
            return true
        }
        return false
    }
    
//    var validText: String?
//    var nonValidText: T?
    var validation: Validation?{
        didSet {
            switch validation {
            case .success(let validationResult):
                text = validationResult.message
                textColor = .systemBlue
            case .fail(let validationResult):
                text = validationResult.message
                textColor = .systemRed
            case nil:
                text = nil
            }
//            text = validation.
//            textColor = isValid ? .systemBlue : .systemRed
        }
    }
    
    init(validation: Validation?) {
        super.init(frame: .zero)
        self.validation = validation
//        self.nonValidText = nonValid
        textColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ValidationResult {
    var message: String { get }
}

enum Validation {
    case success(ValidationResult)
    case fail(ValidationResult)
}
