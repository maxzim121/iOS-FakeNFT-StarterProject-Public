import Foundation
import UIKit

protocol NFTCollectionControllerProtocol: AnyObject {
    func likeButtonTapped(liked: Bool, nftId: String)
    func cartButtonTapped(isEmpty: Bool, nftId: String)
}

final class NFTCollectionViewCell: UICollectionViewCell {
    var delegate: NFTCollectionControllerProtocol?
    var nftId = ""
    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 108, height: 108)
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    lazy var starsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        applyConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViews() {
        contentView.addSubview(nftImageView)
        [likeButton, starsImageView, nameLabel, priceLabel, cartButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func applyConstraints() {
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            starsImageView.heightAnchor.constraint(equalToConstant: 12),
            starsImageView.widthAnchor.constraint(equalToConstant: 68),
            starsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starsImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.topAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    @objc private func didTapLikeButton() {
        let isCompleted = likeButton.currentImage == UIImage(named: "LikeOff")
        if isCompleted {
            delegate?.likeButtonTapped(liked: false, nftId: nftId)
        } else {
            delegate?.likeButtonTapped(liked: true, nftId: nftId)
        }
        let imageName = isCompleted ? "LikeOn" : "LikeOff"
        let image = UIImage(named: imageName)
        likeButton.setImage(image, for: .normal)
    }
    @objc private func didTapCartButton() {
        let currentImage = cartButton.image(for: .normal)
        let emptyCartImage = UIImage(named: "CartEmpty")
        let isCompleted = currentImage?.pngData() == emptyCartImage?.pngData()
        if isCompleted {
            delegate?.cartButtonTapped(isEmpty: true, nftId: nftId)
        } else {
            delegate?.cartButtonTapped(isEmpty: false, nftId: nftId)
        }
        let imageName = isCompleted ? "CartFilled" : "CartEmpty"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        cartButton.setImage(image, for: .normal)
    }
}
