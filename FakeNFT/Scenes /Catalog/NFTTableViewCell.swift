import Foundation
import UIKit
import Kingfisher

final class NFTTableViewCell: UITableViewCell {
    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
    lazy var nftNameAndNumber: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        return label
    }()
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
    }
}
