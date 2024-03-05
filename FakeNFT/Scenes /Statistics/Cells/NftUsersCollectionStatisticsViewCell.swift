//
//  NftUsersCollectionStatisticsViewCell.swift
//  FakeNFT
//
//  Created by Александр Медведев on 24.02.2024.
//

import UIKit

protocol NftUsersCollectionStatisticsViewCellDelegate: AnyObject {
    func cellDidTapLike(_ cell: NftUsersCollectionStatisticsViewCell, _ likeStatus: Bool)
    func cellDidTapBasket(_ cell: NftUsersCollectionStatisticsViewCell, _ inBasket: Bool)
}

final class NftUsersCollectionStatisticsViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NftUsersCollectionStatisticsViewCell"

    weak var delegate: NftUsersCollectionStatisticsViewCellDelegate?

    private var nftImageViewStub = UIImage(named: "nftImageViewStatisticsStub")

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var nftLikeButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(didTapNftLikeButton), for: .touchUpInside)
        return button
    }()

    private var likeStatus = false

    private lazy var nftStarRating: UIImageView = {
        let ratingView = UIImageView()
        ratingView.contentMode = .scaleAspectFill
        return ratingView
    }()

    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .bodyBold
        label.textColor = .yaBlackLight
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .yaBlackLight
        return label
    }()

    private lazy var nftBasketButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(didTapNftBasketButton), for: .touchUpInside)
        return button
    }()

    private var inBasket = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [nftImageView,
         nftLikeButton,
         nftStarRating,
         nftName,
         nftPrice,
         nftBasketButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nftLikeButton.widthAnchor.constraint(equalToConstant: 40),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 40),
            nftLikeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftLikeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nftStarRating.heightAnchor.constraint(equalToConstant: 12),
            nftStarRating.widthAnchor.constraint(equalToConstant: 68),
            nftStarRating.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            nftStarRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            nftName.widthAnchor.constraint(equalToConstant: 68),
            nftName.topAnchor.constraint(equalTo: nftStarRating.bottomAnchor, constant: 5),
            nftName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            nftPrice.widthAnchor.constraint(equalToConstant: 68),
            nftPrice.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            nftPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            nftBasketButton.widthAnchor.constraint(equalToConstant: 40),
            nftBasketButton.heightAnchor.constraint(equalToConstant: 40),
            nftBasketButton.topAnchor.constraint(equalTo: nftStarRating.bottomAnchor, constant: 4),
            nftBasketButton.leadingAnchor.constraint(equalTo: nftName.trailingAnchor)
        ])
    }

    func configure(infoOnNftById: NftByIdServer,
                   _ likeIds: [String],
                   _ orderedIds: [String]) {
        let url = URL(string: infoOnNftById.images[0])
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(with: url, placeholder: nftImageViewStub)

        nftLikeButton.setImage(UIImage(named: "isNotLiked"), for: .normal)
        for likeId in likeIds {
            if infoOnNftById.id == likeId {
                nftLikeButton.setImage(UIImage(named: "isLiked"), for: .normal)
                likeStatus = true
            }
        }

        if infoOnNftById.rating == 0 {
            nftStarRating.image = UIImage(named: "zeroStars")
        } else if infoOnNftById.rating == 1 {
            nftStarRating.image = UIImage(named: "oneStars")
        } else if infoOnNftById.rating == 2 {
            nftStarRating.image = UIImage(named: "twoStars")
        } else if infoOnNftById.rating == 3 {
            nftStarRating.image = UIImage(named: "threeStars")
        } else if infoOnNftById.rating == 4 {
            nftStarRating.image = UIImage(named: "fourStars")
        } else if infoOnNftById.rating >= 5 {
            nftStarRating.image = UIImage(named: "fiveStars")
        }

        nftName.text = infoOnNftById.name

        nftPrice.text = "\(infoOnNftById.price) ETH"

        nftBasketButton.setImage(UIImage(named: "addToBasket"), for: .normal)
        for orderId in orderedIds {
            if infoOnNftById.id == orderId {
                nftBasketButton.setImage(UIImage(named: "removeFromBasket"), for: .normal)
                inBasket = true
            }
        }
    }

    @objc private func didTapNftLikeButton() {
        UIBlockingProgressHUD.show()
        delegate?.cellDidTapLike(self, likeStatus)
    }

    @objc private func didTapNftBasketButton() {
        UIBlockingProgressHUD.show()
        delegate?.cellDidTapBasket(self, inBasket)
    }
}
