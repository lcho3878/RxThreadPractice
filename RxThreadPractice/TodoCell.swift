//
//  TodoCell.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/4/24.
//

import UIKit
import SnapKit

final class TodoCell: UITableViewCell {
    
    static let id = "TodoCell"
    
    private let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configureDate(_ data: Todo) {
        contentLabel.text = data.content
    }
    
}
