//
//  ValidationLabel.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/2/24.
//

import UIKit

class ValidationLabel: UILabel {
    
    var isValid = false {
        didSet {
            text = isValid ? validText : nonValidText
            textColor = isValid ? .systemBlue : .systemRed
        }
    }
    
    var validText: String?
    var nonValidText: String?
    
    init(valid: String, nonValid: String) {
        super.init(frame: .zero)
        self.validText = valid
        self.nonValidText = nonValid
        textColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
