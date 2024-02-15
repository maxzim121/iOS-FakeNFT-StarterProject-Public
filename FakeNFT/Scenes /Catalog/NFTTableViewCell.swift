import Foundation
import UIKit

final class NFTTableViewCell: UITableViewCell {
    
    var nftImageView: UIImageView = UIImageView()
    var nftNameAndNumber: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureNftImageView()
        configureNftNameAndNumber()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NFTTableViewCell {
    
    func configureNftImageView() {
        contentView.addSubview(nftImageView)
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.contentMode = .scaleAspectFill
        nftImageView.layer.cornerRadius = 12
        nftImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -39)
        ])
        
    }
    
    func configureNftNameAndNumber() {
        contentView.addSubview(nftNameAndNumber)
        nftNameAndNumber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nftNameAndNumber.topAnchor.constraint(equalTo: nftImageView.bottomAnchor),
            nftNameAndNumber.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftNameAndNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftNameAndNumber.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        nftNameAndNumber.textAlignment = .left
        nftNameAndNumber.font = .systemFont(ofSize: 17, weight: .bold)
        nftNameAndNumber.textColor = .black
    }
    
}
