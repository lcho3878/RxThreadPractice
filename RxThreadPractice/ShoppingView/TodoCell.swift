//
//  TodoCell.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift

final class TodoCell: UITableViewCell {
    
    static let id = "TodoCell"
    
    var disposeBag = DisposeBag()
    
    private let contentLabel = UILabel()
    
    let checkButton = {
        let view = UIButton()
//        view.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return view
    }()
    
    let starButton = {
        let view = UIButton()
//        view.setImage(UIImage(systemName: "star"), for: .normal)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureView() {
        contentView.addSubview(checkButton)
        contentView.addSubview(starButton)
        contentView.addSubview(contentLabel)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.width.equalTo(checkButton.snp.height)
        }
        
        starButton.snp.makeConstraints {
            $0.size.equalTo(checkButton)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(4)
            $0.trailing.equalTo(starButton.snp.leading).inset(4)
        }
    }
    
    func configureDate(_ data: Todo) {
        contentLabel.text = data.content
        checkButton.setImage(UIImage(systemName: data.isComleted ? "checkmark.square.fill" : "checkmark.square"), for: .normal)
        starButton.setImage(UIImage(systemName: data.isStared ? "star.fill" : "star"), for: .normal)
    }
    
}
