//
//  RecommendCell.swift
//  RxThreadPractice
//
//  Created by 이찬호 on 8/7/24.
//

import UIKit
import SnapKit

final class RecommendCell: UICollectionViewCell {
    
    static let id = "RecommendCell"
    
    private let label = {
        let view = UILabel()
        view.backgroundColor = .lightGray
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func configureDate(_ data: String) {
        label.text = data
    }
    
}
