//
// Created by Ruslan S. Shvetsov on 22.02.2024.
//

import UIKit

final class MyNFTCell: UICollectionViewCell {

    static let identifier = "MyNFTCellIdentifier"

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
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
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
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Цена"
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        return label
    }()

    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "0 ETH"
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        return label
    }()

    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, priceValueLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
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
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingStack, subtitleLabel])
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

    func configure(with nft: Nft, isLiked: Bool) {
        imageView.kf.setImage(with: nft.images[0])
        setLikeButtonState(isLiked: isLiked)
        titleLabel.text = nft.name
        updateRatingStack(with: nft.rating)
        subtitleLabel.text = "от \(nft.author)"
        priceValueLabel.text = "\(nft.price) ETH"
    }

    // MARK: - Setup

    private func setupViews() {
        [imageView, aboutStack, priceStack, likeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.widthAnchor.constraint(equalToConstant: 108),

            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),

            aboutStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            aboutStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),

            ratingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingStack.heightAnchor.constraint(equalToConstant: 12),

            priceStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceStack.leadingAnchor.constraint(equalTo: aboutStack.trailingAnchor),
            priceStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        priceValueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceValueLabel.setContentHuggingPriority(.required, for: .horizontal)
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

    private func setLikeButtonState(isLiked: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let color = isLiked ? UIColor.yaRedUniversal : UIColor.yaWhiteUniversal
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)?
                .withTintColor(color, renderingMode: .alwaysOriginal)
        likeButton.setImage(image, for: .normal)
    }
}
