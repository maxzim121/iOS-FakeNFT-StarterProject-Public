//
// Created by Ruslan S. Shvetsov on 22.02.2024.
//

import UIKit

final class FavoriteNFTCell: UICollectionViewCell {

    static let identifier = "FavoriteNFTCellIdentifier"
    var likeButtonTapped: (() -> Void)?

    // MARK: - Subviews
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)?
                .withTintColor(.yaRedUniversal, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = "0 ETH"
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()

    private lazy var aboutStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingStack, priceValueLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with nft: Nft) {
        imageView.kf.setImage(with: nft.images[0])
        titleLabel.text = nft.name
        updateRatingStack(with: nft.rating)
        priceValueLabel.text = "\(nft.price) ETH"
    }

    // MARK: - Setup

    private func setupViews() {
        [imageView, aboutStack, likeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),

            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),

            aboutStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            aboutStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            aboutStack.widthAnchor.constraint(equalToConstant: 76),

            ratingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingStack.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    private func updateRatingStack(with rating: Int) {
        ratingStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        let totalStars = 5
        let activeStarImage = UIImage(systemName: "star.fill")?
                .withTintColor(.yaYellowUniversal, renderingMode: .alwaysOriginal)
        let inactiveStarImage = UIImage(systemName: "star.fill")?
                .withTintColor(.yaGrayUniversal, renderingMode: .alwaysOriginal)

        for index in 1...totalStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = index <= rating ? activeStarImage : inactiveStarImage
            ratingStack.addArrangedSubview(starImageView)

            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }

    @objc private func likeButtonPressed() {
        likeButtonTapped?()
    }
}
