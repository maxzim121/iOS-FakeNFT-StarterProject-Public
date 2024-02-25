//
//  NftUsersCollectionStatisticsViewCell.swift
//  FakeNFT
//
//  Created by Александр Медведев on 24.02.2024.
//

import UIKit

final class NftUsersCollectionStatisticsViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NftUsersCollectionStatisticsViewCell"
    //for debug
    private let numberView: UILabel = {
        let number = UILabel()
        return number
    }()
    //end for debug
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [numberView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            numberView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(number: Int) {
        numberView.text = "\(number)"
    }
    
}
